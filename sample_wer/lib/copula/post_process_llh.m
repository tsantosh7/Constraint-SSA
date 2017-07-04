function llh = post_process_llh(llh)

chosen_=log(llh)>-300;
min_llh=min(llh(chosen_));
llh(~chosen_)= min_llh + rand(sum(~chosen_),1) * realmin;

%set nan to take THE minimumm value + a small noise
llh(isnan(llh)) = min_llh + rand(sum(isnan(llh)),1) * realmin;
