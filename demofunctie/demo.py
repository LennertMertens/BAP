import time
start = time.time()
print("Hello everyone, this is a serverless demo function!")
a = range(1000000)
b = []
for i in a:
    b.append(i*2)
end = time.time()
execution_time= end - start
print(execution_time)