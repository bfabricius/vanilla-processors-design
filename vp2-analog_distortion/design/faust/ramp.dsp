import("effect.lib");

// GUI Controls:
O  = hslider("even_harmonics",0,0,0.5,0.01);
D  = hslider("distortion [midi: ctrl 0x70]",0.1,0.01,1,0.01);
g   = hslider("level [midi: ctrl 0x7]",0.1,0,1,0.01);
// process = ramp(0.01) : cubicnl

distortion = cubicnl(O,D); // effect.lib

process = ramp(0.01) : -(1.5) : distortion
with {
  integrator = + ~ _ ;
  ramp(slope) = slope : integrator - 2.0;
};
