import re

from kittens.tui.handler import result_handler

def is_window_vim(window, vim_id):
    fp = window.child.foreground_processes
    return any(re.search(vim_id, p['cmdline'][0] if len(p['cmdline']) else '', re.I) for p in fp)

def main():
    pass

@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    vim_id = args[3] if len(args) > 3 else "n?vim"

    window = boss.window_id_map.get(target_window_id)

    if window is None:
        boss.call_remote_control(window, ('send-key', 'super+i'))
    if is_window_vim(window, vim_id):
        for keymap in key_mapping.split(">"):
            encoded = encode_key_mapping(window, keymap)
            window.write_to_child(encoded)
    else:
        boss.active_tab.neighboring_window(direction)
