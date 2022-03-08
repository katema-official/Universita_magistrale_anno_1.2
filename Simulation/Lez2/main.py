
import random

class Event():
    type = "a"
    time = 0

def get_next_delay(Lambda):     #Lambda is the expected value for the random variable.
    return random.expovariate(Lambda)        #the algorithm for an exponential random variable

def get_service_time(exp_time, std_dev_time):
    return random.normalvariate(exp_time, std_dev_time)

def pharmacy(sim_time, daily_working_time, exp_prescriptions_day, exp_prescr_time, stdev_prescr_time):
    #interesting events:
    #(a) arrival of prescription
    #(s) starting of prescription filling
    #(f) finishing of prescription filling

    busy = False
    in_queue = 0

    events = []

    current = Event()
    current.type = "a"
    current.time = get_next_delay(exp_prescriptions_day / daily_working_time)
    #if we expect 32 prescription daily, how many prescr can we expect for each minute?
    #We divide. Note that we decided to model time (daily_working_time) in minutes, but
    #it's just something we decided. We now just need to be coherent with our decision.

    while current.time < sim_time:
        if current.type == "a":

            e = Event()
            e.type = "a"
            e.time = current.time + get_next_delay(exp_prescriptions_day / daily_working_time)
            events.append(e)

            if not busy:
                e = Event()
                e.type = "f"
                e.time = current.time + get_service_time(exp_prescr_time, stdev_prescr_time)

                events.append(e)

            else:
                in_queue = in_queue + 1



if __name__ == '__main__':
    pass
