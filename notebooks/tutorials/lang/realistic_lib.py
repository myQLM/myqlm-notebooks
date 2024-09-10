from qat.lang.AQASM.misc import build_gate
from qat.lang.AQASM import QRoutine, X

# Importing a carry based adder
from qat.lang.AQASM.classarith import cuccaro_add

# Declaring a DAC implementation of a Toffoli
@build_gate("TOFF", [int], lambda n: n)
def dac_toffoli(n):
    rout = QRoutine()
    controls = rout.new_wires(n - 1)
    target = rout.new_wires(1)
    if n == 3:
        rout.apply(X.ctrl(2), controls, target)
        return rout
    first_half = (n - 1) // 2 + ((n - 1) % 2)
    second_half = (n - 1) // 2
    with rout.compute():
        first_toffoli = dac_toffoli(first_half + 1)
        first_anc = rout.new_wires(1)
        rout.apply(first_toffoli, controls[0:first_half], first_anc)
        rout.set_ancillae(first_anc)
        if second_half > 1:
            second_toffoli = dac_toffoli(second_half + 1)
            second_anc = rout.new_wires(1)
            rout.apply(second_toffoli, controls[first_half:], second_anc)
            rout.set_ancillae(second_anc)
        else:
            second_anc = controls[-1]
    rout.apply(X.ctrl(2), first_anc, second_anc, target)
    rout.uncompute()
    return rout
