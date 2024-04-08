from typing import List
from kitty.boss import Boss

def main(args: List[str]) -> str:
    # this is the main entry point of the kitten, it will be executed in
    # the overlay window when the kitten is launched
    directory = input('New tab: ')
    # whatever this function returns will be available in the
    # handle_result() function
    return directory

def handle_result(args: List[str], directory: str, target_window_id: int, boss: Boss) -> None:
    window = boss.window_id_map.get(target_window_id)
    if window is not None:
        boss.call_remote_control(window, ('action', f'new_tab'))
        boss.call_remote_control(window, ('send-text', 'j ' + directory + '\r'))
        boss.call_remote_control(window, ('action', f'set_tab_title', directory))
        boss.call_remote_control(window, ('launch', f'--location=hsplit', '--cwd=current'))
        boss.call_remote_control(window, ('launch', f'--location=vsplit', '--cwd=current'))
        boss.call_remote_control(window, ('focus-window', 0))
