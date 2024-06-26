function show_align(skeleton1, skeleton2)

mtchim = showsimilarity(imcomplement(full(skeleton1)), imcomplement(full(skeleton2)));

figure;
imshow(mtchim);