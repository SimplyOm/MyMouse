clc;
clear;
close all;

vid = videoinput('winvideo', 1, 'YUY2_640x480');
src = getselectedsource(vid);

mymouse=java.awt.Robot;


triggerconfig(vid, 'manual');
flushdata(vid);
src = getselectedsource(vid);
vid.ReturnedColorspace = 'RGB';
preview(vid);
start(vid);
trigger(vid);
screen = get(0,'ScreenSize')
i=0;
while(i<1000)
    im=getsnapshot(vid);
    im=flipdim(im,2);
    im2=rgb2gray(im);
    im3=im(:,:,1)-im2;
    im4=im3>55;
    se=strel('disk',3);
    im5=imerode(im4,se);
    im5=imdilate(im5,se);
    im5=imfill(im5,'holes');
    comps=bwlabel(im4,8);
    props=regionprops(comps,'centroid','area');
    allAreas = [props.Area];
    [sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
    cursorIn = sortingIndexes(1);
    centroid=props(cursorIn).Centroid;
    mymouse.mouseMove(1.5*centroid(:,1)*screen(3)/640, 1.5*centroid(:,2)*screen(4)/480);
    i=i+1;
end