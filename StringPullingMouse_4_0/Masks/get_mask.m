function mask = get_mask(handles,fn,object)

md = get_meta_data(handles);
if ischar(object)
    masksMap = getParameter(handles,'Masks Order');
    ind = find(strcmp(masksMap,object));
end
if iscell(object)
    masksMap = getParameter(handles,'Masks Order');
    for ii = 1:length(object)
        ind(ii) = find(strcmp(masksMap,object{ii}));
    end
end
if isnumeric(object)
    ind = object;
end
fileName = fullfile(fullfile(md.processed_data_folder,'masks'),sprintf('mask_%d.mat',fn));
if ~exist(fileName,'file')
    mask = [];
    return;
else
    temp = load(fileName);
    pMask = temp.dpMask;
end
bpMask = de2bi(pMask,8); % convert to binary for separating individual masks ... i.e. uncompress
azws = getParameter(handles,'Auto Zoom Window Size');
for ii = 1:length(ind)
    tmask = bpMask(:,ind(ii));% = reshape(mask,numel(mask),1); % put in the mask values at the desired index ind
    tmask1 = double(reshape(tmask,azws(1),azws(2)));
    mask(:,:,ii) = tmask1;
end
