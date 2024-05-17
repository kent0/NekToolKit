# NekToolKit: a light-weight support suite for Nek5000

Author: Kento Kaneko (kaneko@mit.edu)

Date: 2024-05-17

NekToolKit is (currently) a suite of Matlab functions enabling processing of Nek5000-related files. Development is in the early stage and no guarantee of backwards-compatability between commits (alpha). Any feedback / suggestions is welcomed!

## Workflow

The project is motivated around fast TTFP (Time-to-first-plot) measured in GUI manipulation time and not compute-time.

First, `NekToolKit/matlab` should be added to path and then call NekSnaps to create snapshots object which allows easy plotting. An example shown below:

```
addpath('~/NekToolKit/matlab'); % replace with /path/to/NekTookKit/matlab

% first argument optional if 'SESSION.NAME' exists,
% second argument optional
s = NekSnaps('casename',1:10);

s.first('u') % plot the first component of velocity for the first snapshot

% plot the velocity magnitude for the first 10 snapshots
for i=1:10; s.show(i,'umag'); end
```

The initialization process can be scripted by adding the path in `setup.m` and adding conveninece script:

```ns
/Applications/MATLAB_R2023b.app/bin/matlab -nosplash -nodesktop -r 's=NekSnaps(); s.first()'
```

## Future Plans

### On TODO

- Field dump
- Support for opposite endianness 

### Considered

- Pre-processing (.rea, .re2)
- Slicing for `n2to3`-extruded mesh
- Integration
- Mesh Quality
- Python Support
- Julia Support

### Long-Shot

- Direct-Stiffness (reading from .map / ma2)
- Solves
- GUI
