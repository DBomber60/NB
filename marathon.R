library(ggplot2)
library(simmer)
library(dplyr)
library(simmer.plot)
library(parallel)

rm(list=ls())

#ncustomers = 3000
#avgservicetime = 1.3
#min_service_time = 0.5
#walktime = 7/60
#timeopen = 10*60
#arrival_rate = ncustomers/timeopen
#counters = 2
#ppc = 4 # people per counter

marathon_plots = function(arrival_rate, avgservicetime, min_service_time, walktime, ppc, leave_prob) {
  customer <- 
    trajectory("Customer's path") %>%
    leave(prob = function() runif(1) < leave_prob) %>%
    simmer::select(c("counter1", "counter2"), policy = "shortest-queue") %>%
    seize_selected %>%
    timeout(function() {rexp(1, walktime^-1)}) %>%
    timeout(function() {min_service_time+rexp(1, avgservicetime^-1)}) %>% # average service time
    release_selected
  
bank <- 
  simmer("bank") %>%
  add_resource("counter1", ppc) %>%
  add_resource("counter2", ppc) %>%
  add_generator("Customer", customer, function() {c(0, rexp(arrival_rate*600, arrival_rate), -1)})

bank %>% run(until = 600)

a = bank %>% 
  get_mon_arrivals %>%
  mutate(waiting_time = end_time - start_time - activity_time) %>%
  arrange(start_time)

# create data table
greater15 = sum(ifelse(a$waiting_time>15,1,0))
numserved = sum(a$finished==TRUE)
numdropped = sum(a$finished==FALSE)
proplong = greater15/numserved
dtable = as.data.frame(cbind(greater15, numserved, numdropped, proplong))
names(dtable) = c("Number of Customers with Wait > 15 Minutes", "Total Customers Served with Cashier", 
                  "Total Served in Line", "Proportion with Long Wait")


g1 = plot(bank, what="resources", metric="usage", steps=T, names= c("counter1", "counter2"))
g2 = plot(bank, what="arrivals", metric="waiting_time")
return(list(a = g1, b = g2, c = dtable))
#return(list(a = grid.arrange(g1, g2, ncol=1), b = c("hi")))

#return(plot(bank, what="resources", metric="usage", steps=T, names= c("counter1", "counter2")))

}

