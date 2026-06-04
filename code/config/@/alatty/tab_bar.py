# pyright: reportMissingImports=false
# pyright: reportCallIssue=false

from alatty.tab_bar import as_rgb, draw_title
from alatty.utils import color_as_int

def _draw_left_status(dd, sc, tab, before, mtl, index, is_last):
    if dd.leading_spaces:
        sc.draw(" " * dd.leading_spaces)

    # draw tab title
    draw_title(dd, sc, tab, index)

    trailing_spaces = min(mtl - 1, dd.trailing_spaces)
    mtl -= trailing_spaces
    extra = sc.cursor.x - before - mtl
    if extra > 0:
        sc.cursor.x -= extra + 1
        sc.draw("…")
    if trailing_spaces:
        sc.draw(" " * trailing_spaces)

    sc.cursor.fg = 0
    if not is_last:
        sc.cursor.bg = as_rgb(color_as_int(dd.inactive_bg))
        sc.draw(dd.sep)
    sc.cursor.bg = 0
    return sc.cursor.x


def _draw_right_status(sc, is_last):
    if not is_last:
        return sc.cursor.x

    cells = []

    rlen = sum([len(c) for _, c in cells])
    s = sc.columns - sc.cursor.x - rlen
    if s > 0:
        sc.draw(" " * s)

    for fg, cell in cells:
        sc.cursor.fg, sc.cursor.bg, _ = fg, 0, sc.draw(cell)
    sc.cursor.fg, sc.cursor.bg, sc.cursor.x = 0, 0, max(sc.cursor.x, sc.columns - rlen)
    return sc.cursor.x


def draw_tab(dd, sc, tab, before, mtl, index, is_last, _):
    end = _draw_left_status(dd, sc, tab, before, mtl, index, is_last)
    _draw_right_status(sc, is_last)
    return end
