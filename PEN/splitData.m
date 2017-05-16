function [input,test]=splitData(input,yeartest)

test=input(size(input,1)-12*(yeartest)+1:size(input,1),1);
input=input(1:size(input,1)-12*(yeartest),1);

end