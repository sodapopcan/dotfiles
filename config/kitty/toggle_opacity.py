import os
from kitty.boss import Boss

def main(args):
    pass

from kittens.tui.handler import result_handler
@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    dir = os.getcwd()
    with open(dir + "/foo.txt", "w") as fp:
        fp.write("hi there")
