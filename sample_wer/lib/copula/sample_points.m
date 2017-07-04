function npoints = sample_points(points_, plabels_)

% input is points{i} for example
% output is a new, subset bootstrapped points


for n=1:numel(points_.pos),
  idlist = unique(plabels_.pos{n})';
  selected_id = idlist(randi(numel(idlist),1,numel(idlist)));
  npoints.pos{n}=[];
  for j=1:numel(selected_id),
    index = plabels_.pos{n} == selected_id(j);
    npoints.pos{n} = [npoints.pos{n}; points_.pos{n}(index)];
  end;
end;

for n=1:numel(points_.neg),
  idlist = unique(plabels_.neg{n})';
  selected_id = idlist(randi(numel(idlist),1,numel(idlist)));
  npoints.neg{n}=[];
  for j=1:numel(selected_id),
    index = plabels_.neg{n} == selected_id(j);
    npoints.neg{n} = [npoints.neg{n}; points_.neg{n}(index)];
  end;
end;