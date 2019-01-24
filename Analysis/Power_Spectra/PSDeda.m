function [f,s2,cl95]=PSDeda(d,Dt,cl)

%Computing power spectral density according to
%Envrionmental Data Analysis with Matlab, 2nd edition,crib sheet 12.2, p289

%input:
%d=time series (must be an even number)
%Dt=sampling interval
%cl=confidence level (usually 0.95 of 0.99)

%output:
%f=frequency vector
%s2=power spectral density
%cl95=95% confidence interval

%make an even number:

modD=mod(length(d),2); %0 for even numbers, 1 for uneven
if modD==1
    d(length(d))=[];
end

%step 1 compute time and frequency parameters

N=length(d); %sample size, should be even
T=N*Dt; %duration of time series
fmax=1/(2*Dt); %Nyquist frequency
Df=fmax/(N/2); %frequency interval
Nf=N/2+1; %number of non-negative frequencies
f=Df*[0:N/2,-N/2+1:-1]'; %frequency vector

%step 2 pre-process time series
d=d-mean(d); %subtract mean
w=0.54-0.46*cos(2*pi*[0:N-1]'/(N-1)); %Hamming window
dw=d;%w.*d;

%step 3 compute Fourier transform
dtilde=Dt*fft(dw); %---------------------------shouldn't this be normalised by N? - no, think it's in definition of s2
dtilde=dtilde(1:Nf); %-----book used [], changed to ()

%step 4 compute power spectral density
s2=(2/T)*abs(dtilde).^2;

%step 5 plot power spectral density and look for peaks
% f=1./f./49; %convert axis to periodicity normalised by Tc ----- changed to period and normalised with Tc
% figure(2)
% hold on
% semilogx(f(1:Nf),s2,'m','LineWidth',1); %----- was plot

%step 6 compute 95% confidence level-----level could be anything, input cl
%Null Hypothesis: time series is uncorrelated random noise
s2est=std(s2); %variance of time series --------------------book says variance, uses std function on the TIMESERIES????
ff=sum(w.*w)/N; %power in window function -----don't understand this
c=(ff*s2est)/(2*Nf*Df); %scaling constant -----book says sd2est, which doesn't excist, changed it to s2est
cl95=c*chi2inv(cl,2); %95% confidence level

% %step 7 plot conf level and assess significance of peaks
% hold on
% semilogx([f(2),f(Nf)],[cl95,cl95],'k-'); %---- was plot and changed f(1) to f(2) because f(1)=inf when using periods
% hold off

end
