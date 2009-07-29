%CHOOSE MAP projection here
function setproj(pollimits)

global MSTRUCT;
MSTRUCT = defaultm('lambert');
MSTRUCT.maplatlimit = [42 85];
MSTRUCT.maplonlimit = [-150 -50];
%MSTRUCT.trimlat = [40 90];
%MSTRUCT.trimlon = [-155 -50];
MSTRUCT.mapparallels = [49 77];
MSTRUCT.nparallels = 2;
MSTRUCT=defaultm(MSTRUCT);


