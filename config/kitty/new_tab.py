import os
import subprocess

def main(_args) -> str:
    location_and_maybe_name = input('New tab: ')

    return location_and_maybe_name

def handle_result(args, location_and_maybe_name, target_window_id, boss):
    num_windows = int(args[1])
    pieces = location_and_maybe_name.split(':')
    location = pieces[0]

    if location == "":
        location = os.getcwd()
    else:
        location = subprocess.check_output(["autojump", location]).rstrip().decode("utf-8")

    if len(pieces) > 1:
        name = pieces[1]
    else:
        name = os.path.basename(location)

    window = boss.window_id_map.get(target_window_id)

    if window is not None:
        boss.call_remote_control(window, ('launch', '--type=tab', f'--cwd={location}'))
        boss.call_remote_control(window, ('action', 'set_tab_title', name))

        if num_windows > 1:
            boss.call_remote_control(window, ('launch', '--location=hsplit', f'--cwd={location}'))

            if num_windows > 2:
                boss.call_remote_control(window, ('launch', '--location=vsplit', f'--cwd={location}'))
                boss.call_remote_control(window, ('action', 'previous_window'))

            boss.call_remote_control(window, ('action', 'previous_window'))
            boss.call_remote_control(window, ('action', 'resize_window taller 20'))
