# NekToolKit: a light-weight support suite for Nek5000

Author: Kento Kaneko (kaneko@mit.edu)

Date: 2024-05-17

NekToolKit is (currently) a suite of Matlab functions enabling processing of Nek5000-related files. Development is in the early stage and no guarantee of backwards-compatability between commits (alpha). Any feedback / suggestions is welcomed!

## Workflow

This project's original motivation was for a fast TTFP (Time-to-first-plot), measured in GUI manipulation time and not compute-time.

First, `NekToolKit/matlab` should be added to path and then call `NekSnaps` to create snapshots object which allows easy plotting. An example shown below:

```
addpath('~/NekToolKit/matlab'); % replace with /path/to/NekTookKit/matlab

% first argument optional if 'SESSION.NAME' exists,
% second argument optional
s = NekSnaps('casename',1:10);

s.first('u1') % plot the first component of velocity for the first snapshot

% plot the velocity magnitude for the first 10 snapshots
for i=1:10; s.show(i,'u_abs'); end
```

The initialization process can be scripted by adding the path in `setup.m` and adding conveninece script:

```ns
/Applications/MATLAB_R2023b.app/bin/matlab -nosplash -nodesktop -r 's=NekSnaps(); s.first()'
```

### Supported fields

- 'x1', 'x2': mesh position components
- 'u1', 'u2': velocity components
    - 'u\_abs': velocity magnitude
    - 'u\_div': velocity divergence
    - 'u\_div': vorticity
- 'p': pressure
    - 'p\_lap': pressure Laplacian
- 't': temperature
- 's1', 's2', ... : passive-scalars

## Future Plans

### On TODO

- Frame rendering
- Field dump
- Support for opposite endianness 

### Considered

- Pre-processing (.rea, .re2)
- Slicing for `n2to3`-extruded mesh
- Integration
- Mesh quality
- Python support
- Julia support

### Long-Shot

- Direct-stiffness (reading from .map / ma2)
- Solves
- GUI
