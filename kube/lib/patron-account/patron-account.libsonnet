(import './secrets.libsonnet') +
{
  local configMap = $.core.v1.configMap,
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local port = $.core.v1.containerPort,
  local ingress = $.extensions.v1beta1.ingress,

  local config = $._config.patron_account,
  local images = $._images.patron_account,
  

  configMap: configMap.new("patron-account-config") +
             configMap.withData($.configMapData),

  patron_account: {
    web: {
      deployment: deployment.new(
        name=config.web.name,
        replicas=1,
        containers=[
          container.new(
            config.web.name, 
            images.web
          ) + 
          container.withPorts(
            [port.new('ui', config.web.port)]
          ) + container.withEnvFrom( {configMapRef: { name: 'patron-account-config' }} 
          ) + container.withEnv( $._secrets + 
              [ { 
                  name: 'PATRON_ACCOUNT_BASE_URL', 
                  value: 'https://' + config.web.host, 
                } ],
          ), 
        ]
      ) + 
      deployment.spec.template.spec.withImagePullSecrets([{name: "github-packages-read"}]),

      service: $.util.serviceFor(self.deployment) + $.core.v1.service.mixin.spec.withPorts($.core.v1.service.mixin.spec.portsType.newNamed(
        name=config.web.name,
        port=80,
        targetPort=config.web.port,
      )),
    },
  },
}
