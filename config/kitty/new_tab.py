import os

def main(_args) -> str:
    location_and_maybe_name = input('New tab: ')

    return location_and_maybe_name

def handle_result(args, location_and_maybe_name, target_window_id, boss):
    num_windows = int(args[1])
    pieces = location_and_maybe_name.split(':')
    location = pieces[0]

    if len(pieces) > 1:
        name = pieces[1]
    else:
        if location == "":
            name = os.getcwd()
        else:
            name = location

    window = boss.window_id_map.get(target_window_id)

    if window is not None:
        if location != "":
            boss.call_remote_control(window, ('action', 'new_tab'))
            boss.call_remote_control(window, ('send-text', 'j ' + location + '\r'))
        else:
            boss.call_remote_control(window, ('action', 'new_tab_with_cwd'))

        boss.call_remote_control(window, ('action', 'set_tab_title', name))

        if num_windows > 1:
            boss.call_remote_control(window, ('launch', '--location=hsplit', '--cwd=current'))
            boss.call_remote_control(window, ('send-text', 'j ' + location + '\r'))

            if num_windows > 2:
                boss.call_remote_control(window, ('launch', '--location=vsplit', '--cwd=current'))
                boss.call_remote_control(window, ('send-text', 'j ' + location + '\r'))
                boss.call_remote_control(window, ('action', 'previous_window'))

            boss.call_remote_control(window, ('action', 'previous_window'))
            boss.call_remote_control(window, ('action', 'resize_window taller 20'))

        else:
            boss.call_remote_control(window, ('action', 'previous_window'))
