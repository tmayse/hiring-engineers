FROM datadog/agent:latest

VOLUME /var/run/docker.sock:/var/run/docker.sock:ro
VOLUME /sys/fs/cgroup/:/host/sys/fs/cgroup:ro

ENV DD_API_KEY=${DD_API_KEY}
ENV DD_TAGS=eehdd
ENV DD_APM_ENABLED=0
ENV DD_LOGS_ENABLED=1
ENV DD_PROCESS_AGENT_ENABLED=0
ENV DD_DOCKER_LABELS_AS_TAGS=0
# ENV DD_HOSTNAME=hostname to use for metrics (if autodetection fails)
