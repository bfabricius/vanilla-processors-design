// Enter Faust code here
import("stdfaust.lib");
ds1clp(x) = tanh(x);
ds1clp_int(x) = (exp(-x) + exp(x)) : *(1/2) : log;
ds1clp_ilo(x) = x <: integrator,differentiator : /
with {
    integrator(x) = _ <: ds1clp_int, (mem : ds1clp_int) : -;
    differentiator(x) = ds1clp,(mem : ds1clp) : -;
};

process = ds1clp_ilo;
