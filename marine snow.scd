(
SynthDef(\bpfsaw,{
	arg atk=2,sus=0,rel=3,c1=1,c2=(-1),
	freq=500,detune=0.2,pan=0,cfhzmin=0.1,cfhzmax=0.3,
	cfmin=500,cfmax=2000,rqmin=0.1,rqmax=0.2,
	lsf=200,ldb=0,amp=1,out=0;
	var sig,env;
	env=EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],
	[c1,0,c2]),doneAction:2);
	sig=Saw.ar(freq*{LFNoise1.kr(0.5,detune).midiratio}!2);
	sig=BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,lsf,0.5,ldb);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig*env*amp;
	Out.ar(out,sig)；
}).add;
)

s.boot;


(
~marimba = Pbind(
	\instrument,\bpfsaw,
	\dur,Prand([1,2,3,4],inf),
	\freq,Prand([1/2,2/3,1,4/3,2,5/2,3,4,6,8],inf),
	\detune,Pwhite(0,0.1,inf),
	\rqmin,0.005,
	\rqmax,0.008,
	\cfmin,Prand((Scale.major.degrees+64).midicps,inf) * Prand([0.5,1,2,4],inf),
	\cfmax,Pkey(\cfmin) * Pwhite(1.008,1.025,inf),
	\atk,3,
	\sus,1,
	\rel,5,
	\amp,1,
	\out,0,
).play;
)


(
~marimba = Pbind(
	\instrument,\bpfsaw,
	\dur,Prand([1],inf),
	\freq,Prand([4/3],inf),
	\detune,0,
	\rqmin,0.005,
	\rqmax,0.008,
	\cfmin,Prand((Scale.major.degrees+64).midicps,inf) * Prand([0.5,1,2],inf),
	\cfmax,Pkey(\cfmin) * Pwhite(1.008,1.025,inf),
	\amp,1,
).play;
)

~marimba.stop;
marimba.free;



s.prepareForRecord; // you have to call this first

s.record;

s.pauseRecording; // pausable

s.record // start again

s.stopRecording; // this closes the file and deallocates the buffer recording node, etc.

x.free; // stop the synths

// look in your recordings folder and you'll find a file named for this date and time




(
Synth.new(
	\bpfsaw,
	[
		\freq,2,
		\atk,0,
		\rqmin,0.005,
		\rqmax,0.008,
	]
);
)






(
~chords = Pbind(
	\instrument,\bpfsaw,
	\dur,Pwhite(4,5,7,0,inf),
	\midinote,Pxrand([
		[23,35,54,63,64],
		[45,52,54,59,61,64],
		[28,40,47,56,59,63],
		[42,52,57,61,63],
	],inf),
	\detune,Pexprand(0.05,0.2,inf),
	\cfmin,100,
	\cfmax,1500,
	\rqmin,Pexprand(0.01,0.15,inf),
	\atk,Pwhite(2.0,2.5,inf),
	\rel,Pwhite(6.5,10.0,inf),
	\ldb,6,
	\amp,0.1,
	\out,0,
).play;
)



//dark sea beach
(
x=Ndef(\alone, { arg amp=0.5;
        var source, local, lfo;

        lfo = LFNoise1.kr(0.32).abs*50+[70,0.01];
        source = Decay.ar(Impulse.ar(lfo), 0.1) * WhiteNoise.ar(0.2);
        source = source * [LFNoise1.ar(0.17,0.4,1.1), LFNoise1.ar(0.57,1,1)];
        source = source;

        local = LocalIn.ar(2) + source;

        local = LPF.ar(local, 400 + LFNoise1.kr(0.1,300,100)) * 1.5;
        local = HPF.ar(local, 100 + LFNoise1.kr(0.15,050,050)) * 1.0;
        local = DelayN.ar(local, 0.2, 0.1);

        local = Limiter.ar(local.reverse,0.5);
        LocalOut.ar(local * 0.6);
        local = [local, Decay.ar(Impulse.ar(LFNoise1.kr(2.12).exprange(2,400)), 0.2 + LFNoise1.kr(0.11,0.1)) * local];
        local = FreqShift.ar(local, LFNoise1.kr(LFNoise1.kr(0.21).exprange(0.1,5)).exprange(0.1,500));
        local = HPF.ar(local, LFNoise1.kr(0.4).range(50,170), LFNoise1.kr(0.1).range(0.1,0.7));

        Splay.ar(local, LFNoise1.kr(0.21).range(0,1)) * amp;
}).play;
)
x.set(\amp,0.8);
