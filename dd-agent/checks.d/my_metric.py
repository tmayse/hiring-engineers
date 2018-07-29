from checks import AgentCheck
import random
class my_metric(AgentCheck):
    def check(self, instance):
        val = random.uniform(0,1000)
        self.gauge('my_metric ', val, tags=[u'ddhee',u'maint:tmayse'])