% SP_BSPLINE_FLUID_2D_PHYS: Construct different pair of B-Splines spaces on the physical domain for fluid problems.
%
%   [spv, spp, PI] = sp_bspline_fluid_2d_phys (knotsv1, degreev1, ...
%          knotsv2, degreev2, knotsp, degreep, msh)
%
% INPUTS:
%
%   elem_name: the name of the element. Right now 'TH' (Taylor-Hood), 
%               'NDL' (Nedelec, 2nd family), 'RT' (Raviart-Thomas) and
%               'SG' (SubGrid) are supported.
%   knotsv1:   knot vector of the space for the first parametric component of 
%               the velocity along each parametric direction
%   degreev1:  degree of the space for the first parametric component of
%               the velocity along each parametric direction
%   knotsv2:   knot vector of the space for the second parametric component of 
%               the velocity along each parametric direction
%   degreev2:  degree of the space for the second parametric component of
%               the velocity along each parametric direction
%   knotsp:    knot vector of the pressure space along each parametric direction
%   degreep:   degree of the pressure space along each parametric direction
%   msh:       msh class containing (in the field msh.qn) the points 
%                along each parametric direction in the parametric 
%                domain at which to evaluate, i.e. quadrature points 
%                or points for visualization (see msh_2d)
%
% OUTPUT:
%
%   spv: class representing the discrete velocity function space (see sp_vector_2d, sp_vector_2d_piola_transform)
%   spp: class representing the discrete pressure function space (see sp_bspline_2d)
%   PI:  a projection matrix for the application of boundary conditions
%         for Raviart-Thomas spaces. The identity matrix in all other cases.
%
%   For more details, see:
%      A.Buffa, C.de Falco, G. Sangalli, 
%      IsoGeometric Analysis: Stable elements for the 2D Stokes equation
%      IJNMF, 2010
%
% Copyright (C) 2009, 2010, 2011 Carlo de Falco
% Copyright (C) 2011 Rafael Vazquez
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [spv, spp, PI] = sp_bspline_fluid_2d_phys (element_name, ...
              knotsv1, degreev1, knotsv2, degreev2, knotsp, degreep, msh)

spp = sp_bspline_2d (knotsp, degreep, msh);

switch (lower (element_name))
  case {'th', 'sg'}
    sp1 = sp_bspline_2d (knotsv1, degreev1, msh);
    sp2 = sp_bspline_2d (knotsv2, degreev2, msh);
    spv = sp_vector_2d (sp1, sp2, msh);

    PI = speye (spp.ndof);
  case {'ndl'}
    sp1 = sp_bspline_2d (knotsv1, degreev1, msh);
    sp2 = sp_bspline_2d (knotsv2, degreev2, msh);
    spv = sp_vector_2d_piola_transform (sp1, sp2, msh);

    PI = speye (spp.ndof);
  case {'rt'}
    sp1 = sp_bspline_2d (knotsv1, degreev1, msh);
    sp2 = sp_bspline_2d (knotsv2, degreev2, msh);
    spv = sp_vector_2d_piola_transform (sp1, sp2, msh);

    PI = b2nst__ (spp, knotsp, degreep, msh);
  otherwise
    error ('sp_bspline_fluid_2d_phys: unknown element type')
end

end

