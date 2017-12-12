function plotMatrix(M)

    if size(find(M),1)~= size(M,1)*size(M,1)
    %// Generate example matrix
    

    %// Do the plot
    cmap = jet; %// choose a colormap
    s = 15; %// dot size
    colormap(cmap); %// use it
    [ii, jj, Mnnz] = find(M); %// get nonzero values and its positions
    scatter(1,1,s,0) %// make sure the first color corresponds to 0 value.
    hold on
    scatter(ii,jj,s,Mnnz); %// do the actual plot of the nonzero values
    set(gca,'color',cmap(1,:)) %// set axis backgroud to first color
    colorbar %// show colorbar
    end
end

