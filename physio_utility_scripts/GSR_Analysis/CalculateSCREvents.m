function [anticipation_events,...
    video_events,...
    rating_events,...
    isi_events]...
                = CalculateSCREvents(trial_times,...
                    peak_EDA_uS,peak_time_sec,SCR_percent_cutoff)
    
    num_trials = length(trial_times(:,1));
    
    %pre-initialized
    video_events = zeros(num_trials,1);
    anticipation_events = zeros(num_trials,1);
    isi_events = zeros(num_trials,1);
    rating_events = zeros(num_trials,1);

    word_onset = 4;%based on log file for affvids
    word_offset = 5;%based on log file for affvids
    video_onset = 10;%based on log file for affvids
    video_offset =11;%based on log file for affvids
    video_rating_resp_times = [16, 17, 18, 19];

    for i=1:num_trials
        %how many anticipations events are there
        anticipation_events(i) = CalculateSCREventsPerTrial(...
            trial_times(i,word_onset), ...
            (trial_times(i,word_offset)+8),...
            peak_time_sec, peak_EDA_uS,...
            SCR_percent_cutoff);
        
                %how many video SCR events were there
         video_events(i)= CalculateSCREventsPerTrial(...
           trial_times(i,video_onset),...
            trial_times(i,video_offset),...
            peak_time_sec,...
            peak_EDA_uS,...
            SCR_percent_cutoff);
        
        video_offset_time = trial_times(i,video_offset);
        rating_time = sum(trial_times(i,video_rating_resp_times));
        rating_finished_time = video_offset_time + rating_time;
        
        rating_events(i) = CalculateSCREventsPerTrial(...
            trial_times(i,video_offset),...
            rating_finished_time,...
            peak_time_sec,...
            peak_EDA_uS,...
            SCR_percent_cutoff);
        
        if(i<num_trials)
            %get start of next word
            next_log_file_row = trial_times(i+1,:);
            next_trial_begins = next_log_file_row(word_onset);
            isi_events(i) = CalculateSCREventsPerTrial(...
                rating_finished_time,...
                next_trial_begins,...
                peak_time_sec,...
                peak_EDA_uS, ...
                SCR_percent_cutoff);
        end
    end
end

