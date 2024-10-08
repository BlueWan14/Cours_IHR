function [FREQV, WAVE, feature] = process(data, time, FREQV, WAVE, lenFFT, dt)

fe=1/dt;
data_wnd = data;
feature = zeros(5,1);
FREQVT = zeros(1,65);
ACCEL = zeros(128,1);

fontsize=16;
font='Times';

    wnd = hamming(lenFFT);
    data_wnd = data.*wnd;
   
    FREQVT = 0:fe/lenFFT:lenFFT/2*fe/lenFFT;
    % calcul de la fft, fftshift
    ACCEL = fft(data_wnd, lenFFT);
    ACCEL = ACCEL.*conj(ACCEL)/lenFFT;
    WAVE = ACCEL(2:lenFFT/2+1);
    FREQV = FREQVT(2:end);

    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calcul des features
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
%     feature(1, i) = mean(accelf);
%     feature(2, i) = std(accelf);
%     feature(3, i) = var(accelf);
%     feature(4, i) = energy(accelf);
%     feature(5, i) = kurtosis(accelf)/10;
%     feature(6, i) = skewness(Xaccelf)
    

      %feature(1,:) = -0.015*feature(5,:) + 500*feature(2,:);
      %feature(1,:) = feature(5, i)-550*(feature(2,:)-20*feature(3,:));
      %feature(1,:) = feature(5, i)-550*(feature(2,:)-20*feature(3,:));
      %feature(1,:) = feature(5, i)-700*(feature(2,:));%-15*feature(3,:));
      
%     feature(2) = feature(2)/max(feature(2));
%     feature(3) = feature(3)/max(feature(3));
%     feature(4) = feature(4)/max(feature(4));
%     feature(5) = feature(5)/max(feature(5));





