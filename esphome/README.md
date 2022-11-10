
# install esphome
```
pip install --upgrade esphome
```

# todo
add distance logics

# Preparation
* Adapt config.yaml to your needs
* Adapt sensor_temperature.yaml with your temperature sensors
* Adapt wifi.yaml + secrets.yaml

# compile to check for errors
```
esphome compile config.yaml
```

# compile & upload
```
esphome run config.yaml
```
