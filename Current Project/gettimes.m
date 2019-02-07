function times = gettimes(soundfile)


freq = 8000;


y = abs(getaudiodata(soundfile));
for R = 1:200
    y(R) = 0;
end
plot(y);
hold on;
envelope = imdilate(y, true(1500, 1 ));
plot(envelope);
quietParts = envelope > (max(y)/7);
plot(quietParts);
times = duration(0,0,find(diff(quietParts) == 1)/freq);


end


