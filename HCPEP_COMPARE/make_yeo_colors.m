
function make_yeo_colors

load YeoROIs.mat
YeoColor = [120 18 134; 70 30 180; 0 118 14; 196 58 250; 220 248 164; 230 148 34; 205 62 78; 0 0 256; 0 0 0; 0 0 1]./256;
YeoColors = zeros(116,3);

j=1;

for i=1:116
    if yeoROIs(i) == j
        YeoColors(i,:) = YeoColor(j,:);
    else
        YeoColors(i,:) = YeoColor(j+1,:);
        j=j+1;
    end
end
save YeoColors YeoColors
Yeo_names={'VIS','SMT','DAT','VAT','LBC','FPA','DMN','SC','CB'};