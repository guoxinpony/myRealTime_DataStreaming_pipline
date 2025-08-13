# test connection to 127.0.0.1:9092, the kafka server
# from confluent_kafka import Producer
# p = Producer({'bootstrap.servers': '127.0.0.1:9092'})
# p.produce('users_created', value=b'test')
# p.flush()

# producer test
# from confluent_kafka import Producer

# def dr(err, msg):
#     if err is None:
#         print(f"delivered to {msg.topic()}@{msg.partition()} offset={msg.offset()}")
#     else:
#         print(f"delivery failed: {err}")

# p = Producer({'bootstrap.servers': '127.0.0.1:9092'})
# p.produce('users_created', value=b'test', callback=dr)
# p.flush(10)

# consumer test
from confluent_kafka import Consumer

c = Consumer({
    'bootstrap.servers': '127.0.0.1:9092',
    'group.id': 'demo-read',
    'auto.offset.reset': 'latest'  #  'earliest'
})
c.subscribe(['users_created'])

for _ in range(5):
    msg = c.poll(5)
    if msg and not msg.error():
        print(msg.topic(), msg.partition(), msg.offset(), msg.value()[:120])
c.close()
