from qat.lang.AQASM import QRoutine, X
from qat.lang.AQASM.misc import build_gate

# Importing a QFT based adder
from qat.lang.AQASM.qftarith import add

# Declaring a straightforward implementation of a Toffoli
@build_gate("TOFF", [int], lambda n: n)
def standard_toffoli(n):
    rout = QRoutine()
    wires = rout.new_wires(n)
    rout.apply(X.ctrl(n - 1), wires)
    return rout