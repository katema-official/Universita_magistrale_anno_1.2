
import random
import numpy

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

    e = Event()
    e.type = "A"
    e.time = get_next_delay(exp_prescriptions_day / daily_working_time)
    #if we expect 32 prescription daily, how many prescr can we expect for each minute?
    #We divide. Note that we decided to model time (daily_working_time) in minutes, but
    #it's just something we decided. We now just need to be coherent with our decision.
    events.append(e)


    while len(events) > 0:

        # pick next event (that one of minimum time in events)
        k = numpy.argmin([events[i].time for i in range(len(events))])
        current = events[k]
        events = events[:k] + events[k + 1:]

        #print("Handling event at time ", current.time, " of type ", current.type)
        #print("System status: pharmacist busy: ", busy, " queue: ", in_queue)

        if current.type == "A":
            e = Event()
            e.type = "A"
            e.time = current.time + get_next_delay(exp_prescriptions_day / daily_working_time)

            #if in_queue < 5
            if e.time <= daily_working_time:    #if the shop is not closed...
                events.append(e)

            if not busy:
                #e = Event()
                #e.type = "f"
                #e.time = current.time + get_service_time(exp_prescr_time, stdev_prescr_time)
                #events.append(e)

                e = Event()
                e.type = "S"
                e.time = current.time

                events.append(e)

            else:
                in_queue = in_queue + 1
            #else:
                #lost_prescriptions += 1
        elif current.type == "S":

            busy = True

            s_time = get_service_time(exp_prescr_time, stdev_prescr_time)

            e = Event()
            e.type = "F"
            e.time = current.time + s_time

            events.append(e)
        elif current.type == "F":

            busy = False
            #now we can start working on a new prescription, if there is one
            if in_queue > 0:
                e = Event()
                e.type = "S"
                e.time = current.time

                events.append(e)

                in_queue = in_queue - 1
    #return max(current.time, daily_working_time)
    return current.time >= 510


if __name__ == '__main__':
    t = [pharmacy(600, 480, 32, 10, 4) for i in range(1000)] #circa 490
    media = numpy.mean(t)
    print("Closing time: ", media)