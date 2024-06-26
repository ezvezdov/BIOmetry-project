function x = showsimilarity(db, input)

    
Color = db + 1;
[I, J] = find(input == 1);
 
for i = 1 : length(I)
    Color(I(i), J(i)) = 3;
end
  
map = [1 1 1;0.7 0 0;0 0 0];
x = ind2rgb(Color, map);
%figure, imshow(x)