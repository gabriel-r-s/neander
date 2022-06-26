import os

def analize():
    assert os.getcwd().endswith("neander")

    os.system("cd build")
    os.system("ghdl -a ../vhdl/")
    os.system("cd -")

def elab_wave(unit):
    assert os.getcwd().endswith("neander")

