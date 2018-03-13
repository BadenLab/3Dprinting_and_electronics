
function spikelingFunctions(filename)
   %% Main spikeling function
   dat = loadSpikelingData(filename);
   dat = findSpikes(dat);
   dat = convertToFreqISI(dat);
   
  % dat = sta(dat);
   dat = checkStim(dat);
   plotall(dat)
   if dat.stim.stimPres==1
    dat = eventThings(dat);
    plotEvents(dat)
   end
   save spikeDat
end


function dat = checkStim(dat);
%% Checks if stim is present
    nPts = length(dat.v);
    nOns = 0;
    for i=2:nPts
        if (dat.stimState(i-1)==0 && dat.stimState(i)==1)
           nOns= 1;
           break
        end
    end
    
    dat.stim.stimPres = nOns;
end
    
function dat = loadSpikelingData(filename)
    %% Load data from csv file saved as filename

    datM = load(filename); % how matlab loads
    datMat = sortrows(datM,9); % sort (sometimes the data isn't sorted in time)
    % convert data from a matrix to a struct - makes things easier
    dat.v = datMat(1:2:end,1);
    dat.totC = datMat(1:2:end,2);
    dat.stimState = datMat(1:2:end,3);
    dat.syn1State = datMat(1:2:end,4);
    dat.syn2State = datMat(1:2:end,5);
    dat.pdCurrent = datMat(1:2:end,6);
    dat.totAnIn = datMat(1:2:end,7);
    dat.totSynC = datMat(1:2:end,8);
    dat.time = datMat(1:2:end,9)./1000./1000; %converted to seconds
    % every other point (spikeling is sending duplicaate values)
    dat.time = dat.time - dat.time(1); % set first time to zero
  
end

function plotall(dat)
    
    mx =max(dat.v);
    figure('pos',[100 100 800 600])
    %% Plot voltage and spikes location markers
    set(gcf,'color','white')
    ax1 = subplot(4,1,2);
    plot(dat.time,dat.v,'k')
    hold on
    if dat.spikesPres==1
        scatter(dat.spikeTimes,mx*ones(1,length(dat.spikeTimes)),2,'k');
    end
    set(gca,'fontsize',8)
    ylabel('Voltage (mV)','fontsize',10) % edit TB
    box off
    set(gca,'xtick',[])
    
    p1 = get(ax1,'Position');
    %% Plot currents
    ax2 = subplot(4,1,3);
    plot(dat.time,dat.totC,'k')
    box off
    set(gca,'xtick',[])
    hold on 
    plot(dat.time,dat.pdCurrent,'Color',[.25 .25 .25])
    plot(dat.time,dat.totAnIn,'Color',[.5 .5 .5])
    set(gca,'fontsize',8)
    ylabel('Currents (AU)','fontsize',10) % edit TB
    legend('Total Current','Photodiode Current','Total Analog Input')
    p2 = get(ax2,'Position');
%% Plot frequencies
    ax3 = subplot(4,1,1);
    p3 = get(ax3,'Position');
    plot(dat.time,dat.spikeFreq,'k')
    set(gca,'fontsize',8)
    ylabel('Spike Rate (Hz)','fontsize',10) % edit TB
    box off
    set(gca,'xtick',[])
    
    %% Plot synapse and stimulus states
    ax4 = subplot(4,1,4);
    plot(dat.time,dat.syn1State,'Color',[.5 .5 .5])
    hold on
    plot(dat.time,dat.syn2State,'Color',[.25 .25 .25])
    box off
    ylim([-0.1,1.1])
    plot(dat.time,dat.stimState,'k')
    set(gca,'fontsize',8)
    ylabel('Inputs','fontsize',10)
    xlabel('Time (s)','fontsize',10) % edit TB
    
    linkaxes([ax1,ax2,ax3,ax4],'x'); % link axes
        % so changing x on one changes all
    xlim([0,max(dat.time)])
    
    legend('Synapse 1','Synapse 2','Stimulus State')
    supertitle('Spikeling Data','t')
    p4 = get(ax4,'Position');
    
    %% Axis Y positions
    p3(2) = .8;   % rate
    p3(4) = .1;   % rate height
    p1(2) = 0.45; % voltage    
    p1(4) = .3;   % voltage height
    p2(2) = 0.2;  % currents
    p2(4) = .2;   % currents height
    p4(2) = .1;   % stim 
    p4(4) = .05;  % stim height
    set(ax1,'pos',p1)
    set(ax2,'pos',p2)
    set(ax3,'pos',p3)
    set(ax4,'pos',p4)
    
 end

function dat = findSpikes(dat)
%% Finds spikes
    spikeTime = []; % initialize empty vector of spike times (we don't
                        % know how many spikes a priori
    spikeInd = []; % initialize indice vector
    thresh = 10; % must be above this value to be considered a spike
    nPts = length(dat.time); 
    tempTrain = zeros(1,nPts); % initialize a spike train as no zeros
    for i=1:nPts-1 % loop over points in times
        if (dat.v(i) >= thresh  && dat.v(i+1) <thresh)
            % define spikes as the last point above thresh before the v
            % gets reset
            spikeTime(end+1) = dat.time(i); % append new spike
            tempTrain(i) = 1; % add spike to train
            spikeInd(end+1) = i;
        end
    end

    dat.spikeTimes = spikeTime;
    dat.spikeTrain = tempTrain;
    dat.spikeInd = spikeInd;
    if length(spikeTime)>0
        dat.spikesPres = 1;
    else
        dat.spikesPres = 0;
    end
    
end

function dat = eventThings(dat)
%% Finds the points when the stimuli goes from 0 to 1 and pulls stuff
    nPts = length(dat.stimState);
    dat.stim.v = [];
    dat.stim.totC = [];
    dat.stim.pdCurrent = [];
    dat.stim.totAnIn = [];
    dat.stim.meanDT = [];
    dat.stim.freq = [];
    dat.stim.startInd = [];
    dat.stim.spikes = {};
    dat.stim.periCount = [];
    for i=2:nPts
        if (dat.stimState(i-1)==0 && dat.stimState(i)==1)
            dat.stim.startInd(end+1) = i;
        end
    end
    for (i=2:length(dat.stim.startInd))
        interval(i-1) = dat.stim.startInd(i)-dat.stim.startInd(i-1);
    end
    ptsPull = ceil(mean(interval));
    dat.stim.period = dat.time(ptsPull)-dat.time(1);
     
    for (i=2:nPts-ptsPull-1)
        if (dat.stimState(i-1)==0 && dat.stimState(i)==1)
            dat.stim.v(end+1,:) = dat.v(i:i+ptsPull);
            dat.stim.totC(end+1,:) = dat.totC(i:i+ptsPull);
            dat.stim.pdCurrent(end+1,:) = dat.pdCurrent(i:i+ptsPull);
            dat.stim.totAnIn(end+1,:) = dat.totAnIn(i:i+ptsPull);
            dat.stim.meanDT(end+1) = (dat.time(i+ptsPull)-dat.time(i))/ptsPull;
            dat.stim.freq(end+1,:) = dat.spikeFreq(i:i+ptsPull);
            dat.stim.spikes{end+1}(:) = dat.spikeTimes(find(dat.spikeTimes > dat.time(i) & dat.spikeTimes < dat.time(i+ptsPull)));
            dat.stim.spikes{end}= dat.stim.spikes{end} - dat.time(i);
            dat.stim.periCount(end+1) = length(dat.stim.spikes{end});
        end
    end
    periCountMax = max(dat.stim.periCount);
    for i=1:periCountMax+1
        dat.stim.pCount(i) = length(find(dat.stim.periCount==(i-1)))/length(dat.stim.periCount);
    end
    
    dat.stim.allSpikes = cell2mat(dat.stim.spikes) ;
    
        
    
    
    %% Finds when syn1 goes from zero to ones, pulls stuff
    dat.syn1.v = [];
    dat.syn1.totC = [];
    dat.syn1.pdCurrent = [];
    dat.syn1.totAnIn = [];
     dat.syn1.freq = [];
    for (i=2:nPts-ptsPull-1)
        if (dat.syn1State(i-1)==0 && dat.syn1State(i)==1)
            dat.syn1.v(end+1,:) = dat.v(i:i+ptsPull);
            dat.syn1.totC(end+1,:) = dat.totC(i:i+ptsPull);
            dat.syn1.pdCurrent(end+1,:) = dat.pdCurrent(i:i+ptsPull);
            dat.syn1.totAnIn(end+1,:) = dat.totAnIn(i:i+ptsPull);
            dat.syn2.freq(end+1,:) = dat.spikeFreq(i:i+ptsPull);
          
        end
    end
    
    %% Finds when syn2 goes from zero to ones, pulls stuff
    dat.syn2.v = [];
    dat.syn2.totC = [];
    dat.syn2.pdCurrent = [];
    dat.syn2.totAnIn = [];
    dat.syn2.freq = [];
    for (i=2:nPts-ptsPull-1)
        if (dat.syn2State(i-1)==0 && dat.syn2State(i)==1)
            dat.syn2.v(end+1,:) = dat.v(i:i+ptsPull);
            dat.syn2.totC(end+1,:) = dat.totC(i:i+ptsPull);
            dat.syn2.pdCurrent(end+1,:) = dat.pdCurrent(i:i+ptsPull);
            dat.syn2.totAnIn(end+1,:) = dat.totAnIn(i:i+ptsPull);
            dat.syn2.freq(end+1,:) = dat.spikeFreq(i:i+ptsPull);
        end
    end
            
            
end

function plotEvents(dat)
    nBins = 20; % number of bins for peri-histogram
    %% Frequency
    [nCell, nPts] = size(dat.stim.v);
    figure('pos',[930 100 400 600])
    set(gcf,'color','white')
    evax1 = subplot(6,1,1);
    tt = 1:nPts;
    tt = tt .*mean(dat.stim.meanDT);
    plot(tt,dat.stim.freq,'Color',[.5 .5 .5]);  % edit TB
    hold on
    plot(tt,mean(dat.stim.freq),'k','LineWidth',2)  % edit TB
    set(gca,'xtick',[])
    set(gca,'fontsize',8)
    ylabel('Spike Rate (Hz)','fontsize',10) % edit TB
    q1 = get(evax1,'Position');
    box off
    
    %% perihisto
    evax2 = subplot(6,1,2);
    histogram(dat.stim.allSpikes,nBins,'FaceColor',[.5 .5 .5],'EdgeColor','k');
    
    set(gca,'fontsize',8)
    set(gca,'xtick',[]);
    box off
    ylabel('Spikes','fontsize',10) % edit TB
    q2 = get(evax2,'Position');   
    
    %% Raster
    evax3 = subplot(6,1,3);
    set(gca,'Visible','off') 
    hold on
    for i=1:length(dat.stim.spikes)
        scatter(dat.stim.spikes{i},i*ones(1,length(dat.stim.spikes{i})),'.','k');
    end
    set(gca,'xtick',[])
    set(gca,'fontsize',8)       
    ylabel('Spikes','fontsize',10) % edit TB
    box off
    q3 = get(evax3,'Position');
    
    %% Voltage
    evax4 = subplot(6,1,4); 
    plot(tt,dat.stim.v,'Color',[.5 .5 .5])  % edit TB
    hold on
    plot(tt,mean(dat.stim.v),'k','LineWidth',2)
    set(gca,'xtick',[])
    set(gca,'fontsize',8)
    ylabel('Voltage (mV)','fontsize',10) % edit TB
    box off
    q4 = get(evax4,'Position');
    
    %% Current
    evax5 = subplot(6,1,5);
    plot(tt,dat.stim.totC,'Color',[.5 .5 .5]); % edit TB
    hold on
    plot(tt,mean(dat.stim.totC),'k','LineWidth',2);  % edit TB
    set(gca,'fontsize',8)
    ylabel('Current (AU)','fontsize',10) % edit TB
    box off
    xlabel('Time after stimulus (s)','fontsize',10)
    q5 = get(evax5,'Position');

    xlim([0,dat.stim.period])
    
    %% count histo
    evax6 = subplot(6,1,6);
    bar(0:(length(dat.stim.pCount)-1),dat.stim.pCount','FaceColor',[.5 .5 .5],'EdgeColor','k')
    set(gca,'fontsize',8)
    xlabel('Spikes per loop','fontsize',10)
    ylabel('Probability','fontsize',10)
    box off
    q6 = get(evax6,'Position');
 
    %%
    supertitle('Event-triggered Data','t')
    
    %% link axes
    linkaxes([evax1,evax2,evax3,evax4,evax5],'x'); % link axes

        %% Axis Y positions
    q1(2) = .8;   % rate
    q1(4) = .1;   % rate height
   
    q2(2) = .7;   % Hist
    q2(4) = .06;   % Hist height
    
    q3(2) = .61;   % raster
    q3(4) = .06;   % raster height
    
    q4(2) = .4;   % Voltage
    q4(4) = .2;   % Voltage height
    
    q5(2) = .2;   % current
    q5(4) = .15;   % current height
 
    q6(2) = .1;   % nSpikes
    q6(4) = .05;   % nSpikes height
    
    
    
    set(evax1,'pos',q1)
    set(evax2,'pos',q2)
    set(evax3,'pos',q3)
    set(evax4,'pos',q4)
    set(evax5,'pos',q5)
    set(evax6,'pos',q6)
    
    
end

function dat = convertToFreqISI(dat)
    dat.isi = zeros(length(dat.spikeTimes));
    if dat.spikesPres==1
    for i = 2:length(dat.isi)
        dat.isi(i) = dat.spikeTimes(i)-dat.spikeTimes(i-1);
    end
    dat.spikeFreq = dat.time;
    dat.spikeFreq = 0;
    for i = 2:length(dat.isi)
        dat.spikeFreq(dat.spikeInd(i-1):dat.spikeInd(i))=1./dat.isi(i);
    end
    dat.spikeFreq(dat.spikeInd(end):length(dat.time))=0;
    else
       dat.spikeFreq=zeros(length(dat.v));
    end
    

end

function dat = convertToFreq(dat,winSize)
    %% computes instantaneous frequency by sliding sum
    % winsize is in points, not time
    nPts = length(dat.time);
    dat.spikeFreq = dat.time;
    dat.spikeFreq = 0;
    for i=1:nPts-winSize
        dat.spikeFreq(i) = sum(dat.spikeTrain(i:i+winSize))/(dat.time(i+winSize)-dat.time(i));
        % sum the spikes in winSize, divide by length of window
    end
    dat.spikeFreq(nPts-winSize+1:length(dat.time)) = 0;
    
end

function dat = sta(dat)
%% Spike triggered average
    pullWin = 1; % window size
    staMat = []; % initialize matrix
    onWhich = 1;
    for i = find(dat.spikeTimes>pullWin)
        st = find(dat.time==dat.spikeTimes(i)); % indice of spike
        tPre = dat.spikeTimes(i)-pullWin; % time to start pulling
        stMin = find(abs(dat.time-tPre)==min(abs(dat.time-tPre))); % indice of first
        chunk{onWhich} = dat.stimState(stMin:st); % pull out the chunk
        len(onWhich) = length(chunk{onWhich}); % how many points are in the chunk
            % this is here because the sampling rate varies from 3-4 ms
        onWhich=onWhich+1;
    end
    minLen = min(len);
    for i =1:length(chunk)
        staMat(:,end+1) = chunk{i}(end-minLen+1:end); % use the minimum 
    end
    dat.staMat = staMat; % save as matrix
    sta = mean(staMat,2);
    figure 
    xs = linspace(0,pullWin,length(sta));
    plot(xs,sta);
    
    
end

function supertitle(text,whichLabel,supAxes)
 %%

% Author: Ben Barrowes <barrowes@alum.mit.edu>

currax=findobj(gcf,'type','axes','-not','tag','suplabel');

if nargin < 3
 supAxes=[.08 .08 .84 .84];
 ah=findall(gcf,'type','axes');
 if ~isempty(ah)
  supAxes=[inf,inf,0,0];
  leftMin=inf;  bottomMin=inf;  leftMax=0;  bottomMax=0;
  axBuf=.04;
  set(ah,'units','normalized')
  ah=findall(gcf,'type','axes');
  for ii=1:length(ah)
   if strcmp(get(ah(ii),'Visible'),'on')
    thisPos=get(ah(ii),'Position');
    leftMin=min(leftMin,thisPos(1));
    bottomMin=min(bottomMin,thisPos(2));
    leftMax=max(leftMax,thisPos(1)+thisPos(3));
    bottomMax=max(bottomMax,thisPos(2)+thisPos(4));
   end
  end
  supAxes=[leftMin-axBuf,bottomMin-axBuf,leftMax-leftMin+axBuf*2,bottomMax-bottomMin+axBuf*2];
 end
end
if nargin < 2, whichLabel = 'x';  end
if nargin < 1, help(mfilename); return; end

if ~isstr(text) | ~isstr(whichLabel)
  error('text and whichLabel must be strings')
end
whichLabel=lower(whichLabel);

ax=axes('Units','Normal','Position',supAxes,'Visible','off','tag','suplabel');
if strcmp('t',whichLabel)
  set(get(ax,'Title'),'Visible','on')
  title(text);
elseif strcmp('x',whichLabel)
  set(get(ax,'XLabel'),'Visible','on')
  xlabel(text);
elseif strcmp('y',whichLabel)
  set(get(ax,'YLabel'),'Visible','on')
  ylabel(text);
elseif strcmp('yy',whichLabel)
  set(get(ax,'YLabel'),'Visible','on')
  ylabel(text);
  set(ax,'YAxisLocation','right')
end

for k=1:length(currax), axes(currax(k));end % restore all other axes

if (nargout < 2)
  return
end
if strcmp('t',whichLabel)
  h=get(ax,'Title');
  set(h,'VerticalAlignment','middle')
elseif strcmp('x',whichLabel)
  h=get(ax,'XLabel');
elseif strcmp('y',whichLabel) | strcmp('yy',whichLabel)
  h=get(ax,'YLabel');
end

%%%ah=findall(gcf,'type','axes');
%%%'sssssssss',kb
end
