def main():
    pass


from kittens.tui.handler import result_handler
@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)

    if window is None:
        return

    fp = window.child.foreground_processes

    for p in fp:
        if '+iex' in p['cmdline']:
            boss.call_remote_control(window, ('send-text', '#iex:break\n'))
            return

