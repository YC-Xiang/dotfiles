if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# fix tmux can't use VScode 'code' command
# https://github.com/microsoft/vscode-remote-release/issues/2763
socket=$(ls -1t /run/user/$UID/vscode-ipc-*.sock 2> /dev/null | head -1)
export VSCODE_IPC_HOOK_CLI=${socket}
