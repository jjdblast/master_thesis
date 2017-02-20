function [ b_xi_ast ] = resample( b_xi,Nsamples,dimensions)
%RESAMPLE Summary of this function goes here
%   Detailed explanation goes here
U=rand(Nsamples,1);
U_sorted=sort(U);
U_sorted(end+1)=1;
j=1;
b_xi_ast=zeros(Nsamples,dimensions+1);  %Initialize the matrix for the resampled samples
b_xi_ast(:,dimensions+1)=1/Nsamples;    %Assign uniform weight to the resampled samples
CSW=0;
% only required for the case where we do mixture importance sampling
total_number_of_samples=size(b_xi,1);
% 
% figure
for i=1:total_number_of_samples
    
    while((b_xi(i,dimensions+1)+CSW)>U_sorted(j)&& j<=(Nsamples))
        %
%         b_xi(i,dimensions+1)
%         CSW
%         b_xi(i,dimensions+1)+CSW
%         U_sorted(j)
%         plot(b_xi_ast(:,1),b_xi_ast(:,2),'o');
        %
        b_xi_ast(j,1:dimensions)=b_xi(i,1:dimensions);
        j=j+1;
    end
    CSW=CSW+b_xi(i,dimensions+1);
end
end

