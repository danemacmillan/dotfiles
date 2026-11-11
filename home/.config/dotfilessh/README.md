# dotfilessh

This is a builder for passing local dotfiles to remote machines through SSH. The
reason for this is so that remote machines do not need to be polluted with 
persistent dotfile configurations. This technique allows specifying a subset of
aliases, functions, or environment variables that are only available for the
length of the SSH session.

## SSH command to run

```bash
# Directly
ssh -tt storefront-stage "bash --noprofile --rcfile <(printf '%s' $(printf '%q' "$(< ~/.config/dotfilessh/dotfilessh.bash)")) -i"

# GCP
gcloud compute ssh hostname --ssh-flag="-tt" --command="bash --noprofile --rcfile <(printf '%s' $(printf '%q' "$(< $XDG_CONFIG_HOME/dotfilessh/sshtools.bash)")) -i"


ssh -tt storefront-stage "bash --noprofile --rcfile <(printf '%s' $(printf '%q' "$(< ~/.local/share/dotfiles/sshtools.bash)")) -i"

# Using builder you do not pass the builder script contents, you let it execute:
ssh -tt storefront-stage "bash --noprofile --rcfile <(printf '%s' $(printf '%q' "$($XDG_CONFIG_HOME/dotfilessh/dotfilessh.bash)")) -i"
gcloud compute ssh hostname --ssh-flag="-tt" --command="bash --noprofile --rcfile <(printf '%s' $(printf '%q' "$($XDG_CONFIG_HOME/dotfilessh/dotfilessh.bash)")) -i"


```


## Example when no builder involved

This was the first draft where just the contents of a single file were echoed
out and passed to the RC file. The modern approach above is using a builder that
dynamically generates the RC file based on the contents of the dotfileSSH
directory.

```bash

# base64 version

ssh -tt storefront-stage "tmp=\$(mktemp) && base64 -d >\"\$tmp\" <<'__RC__'
$(base64 < ${XDG_DATA_HOME}/dotfiles/sshtools.bash)
__RC__
bash --noprofile --rcfile \"\$tmp\" -i
rm -f \"\$tmp\""




# Or simpler one-liner

ssh -tt storefront-stage "bash --noprofile --rcfile <(printf '%s' $(printf '%q' "$(< ${XDG_DATA_HOME}/dotfiles/sshtools.bash)")) -i"



# Doing it with GCP


gcloud compute ssh storefront-stage \
  --ssh-flag="-tt" \
  --command="tmp=\$(mktemp) && base64 -d >\"\$tmp\" <<'__RC__'
$(base64 < ~/.local/share/dotfiles/sshtools.bash)
__RC__
bash --noprofile --rcfile \"\$tmp\" -i
rm -f \"\$tmp\""




gcloud compute ssh storefront-stage \
  --ssh-flag="-tt" \
  --command="bash --noprofile --rcfile <(printf '%s' $(printf '%q' "$(< ~/.local/share/dotfiles/sshtools.bash)")) -i"



```

