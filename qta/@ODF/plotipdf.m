function plotipdf(odf,r,varargin)
% plot inverse pole figures
%
%% Input
%  odf - @ODF
%  r   - @vector3d specimen directions
%
%% Options
%  RESOLUTION - resolution of the plots
%  
%% Flags
%  antipodal    - include [[AxialDirectional.html,antipodal symmetry]]
%  COMPLETE - plot entire (hemi)--sphere
%
%% See also
% S2Grid/plot savefigure Plotting Annotations_demo ColorCoding_demo PlotTypes_demo
% SphericalProjection_demo 

argin_check(r,{'vector3d'});


%% make new plot
newMTEXplot;

% default options
varargin = set_default_option(varargin,...
  get_mtex_option('default_plot_options'));

%% plotting grid
[maxtheta,maxrho,minrho] = getFundamentalRegionPF(odf(1).CS,varargin{:});
h = S2Grid('PLOT','MAXTHETA',maxtheta,'MAXRHO',maxrho,'MINRHO',minrho,'RESTRICT2MINMAX',varargin{:});

%% plot
disp(' ');
disp('Plotting inverse pole density function:')

multiplot(numel(r),...
  h,...
  @(i) ensureNonNeg(pdf(odf,h,r(i)./norm(r(i)),varargin{:})),...
   'smooth',...
  'TR',@(i) r(i),...
  varargin{:});

%% finalize plot
setappdata(gcf,'r',r);
setappdata(gcf,'CS',odf(1).CS);
setappdata(gcf,'SS',odf(1).SS);
set(gcf,'tag','ipdf');
setappdata(gcf,'options',extract_option(varargin,'antipodal'));
name = inputname(1);
if isempty(name), name = odf(1).comment;end
set(gcf,'Name',['Inverse Pole Figures of ',name]);
