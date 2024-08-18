# Warning: this repository is archived #

Build dpll test container here: https://github.com/vitus133/go-dpll

# Netlink DPLL test container #

This repo helps to build a container image for netlink DPLL debug

## Bulid ##

```bash
export IMG='quay.io/vgrinber/tools:dpll'
```
(replace with your repository)

```bash
podman build -t $IMG --no-cache -f Containerfile  . && podman push $IMG
```

## Hack ##
The [Containerfile](Containerfile) specifies two hacks done to the kernel tools here:

### 1. Add DPLL YNL spec

```
# Comment out this line when dpll.yaml will be upstream
COPY dpll.yaml /linux/Documentation/netlink/specs/dpll.yaml
```

### 2. Make monitoring call blocking

The upstream implementation of `ynl.py` opens the monitoring socket in non-blocking mode, which means that if there is no notification at the exact same moment you run the cli, it will exit.
If we want to wait for notifications, this hack must be done:

```
# Uncomment this line if you want cli to block while waiting on netlink notifications
RUN sed -i 's/, socket.MSG_DONTWAIT//g' lib/ynl.py 
```

## Use ##

### Use netlink cli from linux kernel tools ###

```bash
oc debug no/cnfde21.ptp.lab.eng.bos.redhat.com --image=quay.io/vgrinber/tools@sha256:d953aeefb3cc23ffceddce168f754b251f98b2553b1e3fc85c6f3fa57b480951
Starting pod/cnfde21ptplabengbosredhatcom-debug-tl8hl ...
To use host binaries, run `chroot /host`
Pod IP: 10.16.230.5
If you don't see a command prompt, try pressing enter.

sh-5.1# python3 cli.py --spec /linux/Documentation/netlink/specs/dpll.yaml --dump device-get
[{'clock-id': 5799633565433967664,
  'id': 0,
  'lock-status': 'locked-ho-acq',
  'mode': 'automatic',
  'mode-supported': ['automatic'],
  'module-name': 'ice',
  'type': 'eec'},
 {'clock-id': 5799633565433967664,
  'id': 1,
  'lock-status': 'locked-ho-acq',
  'mode': 'automatic',
  'mode-supported': ['automatic'],
  'module-name': 'ice',
  'type': 'pps'},
 {'clock-id': 5799633565433966964,
  'id': 2,
  'lock-status': 'unlocked',
  'mode': 'automatic',
  'mode-supported': ['automatic'],
  'module-name': 'ice',
  'type': 'eec'},
 {'clock-id': 5799633565433966964,
  'id': 3,
  'lock-status': 'unlocked',
  'mode': 'automatic',
  'mode-supported': ['automatic'],
  'module-name': 'ice',
  'type': 'pps'}]

sh-5.1# python3 cli.py --spec /linux/Documentation/netlink/specs/dpll.yaml --subscribe monitor

```
The last command above will block waiting for a notification.
<<<<<<< HEAD
The last command above will block waiting for a notification.
=======
>>>>>>> add-go-cli

### Use [pre-built](https://github.com/vitus133/go-dpll.git) dpll-cli ###

```bash
§ oc debug no/cnfde22.ptp.lab.eng.bos.redhat.com  --image=quay.io/vgrinber/tools:dpll
Starting pod/cnfde22ptplabengbosredhatcom-debug-762vj ...
To use host binaries, run `chroot /host`
Pod IP: 10.16.230.7
If you don't see a command prompt, try pressing enter.
sh-5.1# dpll-cli 
Interact with dpll devices via netlink

Get and monitor devices and pins.

Usage:
  dpll-cli [command]

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  dumpDevices Dump DPLL devices
  dumpPins    Dump DPLL pins
  help        Help about any command
  monitor     Monitors DPLL events

Flags:
  -h, --help   help for dpll-cli

Use "dpll-cli [command] --help" for more information about a command.
```
#
```bash
sh-5.1§ dpll-cli dumpDevices
{"timestamp":"2024-03-04T13:18:26.12219909Z","id":0,"moduleName":"ice","mode":"automatic","modeSupported":"automatic","lockStatus":"locked-ho-acquired","clockId":"0x507c6fffff1fb4e8","type":"eec","temp":0}
{"timestamp":"2024-03-04T13:18:26.12219909Z","id":1,"moduleName":"ice","mode":"automatic","modeSupported":"automatic","lockStatus":"locked-ho-acquired","clockId":"0x507c6fffff1fb4e8","type":"pps","temp":0}
{"timestamp":"2024-03-04T13:18:26.12219909Z","id":2,"moduleName":"ice","mode":"automatic","modeSupported":"automatic","lockStatus":"locked-ho-acquired","clockId":"0x507c6fffff1fb484","type":"eec","temp":0}
{"timestamp":"2024-03-04T13:18:26.12219909Z","id":3,"moduleName":"ice","mode":"automatic","modeSupported":"automatic","lockStatus":"locked-ho-acquired","clockId":"0x507c6fffff1fb484","type":"pps","temp":0}
```
#
```bash
sh-5.1§ dpll-cli dumpPins   
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":0,"clockId":"0x507c6fffff1fb4e8","boardLabel":"CVL-SDP22","panelLabel":"","packageLabel":"","type":"int-oscillator","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":5,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":1,"clockId":"0x507c6fffff1fb4e8","boardLabel":"CVL-SDP20","panelLabel":"","packageLabel":"","type":"int-oscillator","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":4,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":2,"clockId":"0x507c6fffff1fb4e8","boardLabel":"C827_0-RCLKA","panelLabel":"","packageLabel":"","type":"mux","frequency":1953125,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":8,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":3,"clockId":"0x507c6fffff1fb4e8","boardLabel":"C827_0-RCLKB","panelLabel":"","packageLabel":"","type":"mux","frequency":1953125,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":9,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":4,"clockId":"0x507c6fffff1fb4e8","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":3,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":5,"clockId":"0x507c6fffff1fb4e8","boardLabel":"SMA2/U.FL2","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":2,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":-1025.68},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":7,"clockId":"0x507c6fffff1fb4e8","boardLabel":"REF-SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change","pinParentDevice":{"parentId":1,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":8,"clockId":"0x507c6fffff1fb4e8","boardLabel":"REF-SMA2/U.FL2","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change","pinParentDevice":{"parentId":1,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":9,"clockId":"0x507c6fffff1fb4e8","boardLabel":"PHY-CLK","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":156250000,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":1,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":10,"clockId":"0x507c6fffff1fb4e8","boardLabel":"MAC-CLK","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":156250000,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":1,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":11,"clockId":"0x507c6fffff1fb4e8","boardLabel":"CVL-SDP21","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change","pinParentDevice":{"parentId":1,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":12,"clockId":"0x507c6fffff1fb4e8","boardLabel":"CVL-SDP23","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change","pinParentDevice":{"parentId":1,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":13,"clockId":"0x507c6fffff1fb4e8","boardLabel":"","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":0,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":0,"direction":"","prio":0,"state":"","phaseOffsetPs":0},"pinParentPin":{"parentId":3,"parentState":"disconnected"},"phaseAdjustMin":0,"phaseAdjustMax":0,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":14,"clockId":"0x507c6fffff1fb4e8","boardLabel":"","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":0,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":0,"direction":"","prio":0,"state":"","phaseOffsetPs":0},"pinParentPin":{"parentId":3,"parentState":"disconnected"},"phaseAdjustMin":0,"phaseAdjustMax":0,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":15,"clockId":"0x507c6fffff1fb4e8","boardLabel":"","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":0,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":0,"direction":"","prio":0,"state":"","phaseOffsetPs":0},"pinParentPin":{"parentId":3,"parentState":"disconnected"},"phaseAdjustMin":0,"phaseAdjustMax":0,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":16,"clockId":"0x507c6fffff1fb4e8","boardLabel":"","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":0,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":0,"direction":"","prio":0,"state":"","phaseOffsetPs":0},"pinParentPin":{"parentId":3,"parentState":"disconnected"},"phaseAdjustMin":0,"phaseAdjustMax":0,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":17,"clockId":"0x507c6fffff1fb484","boardLabel":"CVL-SDP22","panelLabel":"","packageLabel":"","type":"int-oscillator","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":5,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":18,"clockId":"0x507c6fffff1fb484","boardLabel":"CVL-SDP20","panelLabel":"","packageLabel":"","type":"int-oscillator","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":4,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":19,"clockId":"0x507c6fffff1fb484","boardLabel":"C827_0-RCLKA","panelLabel":"","packageLabel":"","type":"mux","frequency":1953125,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":8,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":20,"clockId":"0x507c6fffff1fb484","boardLabel":"C827_0-RCLKB","panelLabel":"","packageLabel":"","type":"mux","frequency":1953125,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":9,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":293.35},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":22,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA2/U.FL2","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":2,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":23,"clockId":"0x507c6fffff1fb484","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":0,"state":"selectable","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":24,"clockId":"0x507c6fffff1fb484","boardLabel":"REF-SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change","pinParentDevice":{"parentId":3,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":25,"clockId":"0x507c6fffff1fb484","boardLabel":"REF-SMA2/U.FL2","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change","pinParentDevice":{"parentId":3,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":26,"clockId":"0x507c6fffff1fb484","boardLabel":"PHY-CLK","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":156250000,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":3,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":27,"clockId":"0x507c6fffff1fb484","boardLabel":"MAC-CLK","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":156250000,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":3,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":28,"clockId":"0x507c6fffff1fb484","boardLabel":"CVL-SDP21","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change","pinParentDevice":{"parentId":3,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":29,"clockId":"0x507c6fffff1fb484","boardLabel":"CVL-SDP23","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change","pinParentDevice":{"parentId":3,"direction":"output","prio":0,"state":"connected","phaseOffsetPs":0},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-480307,"phaseAdjustMax":480307,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":30,"clockId":"0x507c6fffff1fb484","boardLabel":"","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":0,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":0,"direction":"","prio":0,"state":"","phaseOffsetPs":0},"pinParentPin":{"parentId":20,"parentState":"disconnected"},"phaseAdjustMin":0,"phaseAdjustMax":0,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":31,"clockId":"0x507c6fffff1fb484","boardLabel":"","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":0,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":0,"direction":"","prio":0,"state":"","phaseOffsetPs":0},"pinParentPin":{"parentId":20,"parentState":"disconnected"},"phaseAdjustMin":0,"phaseAdjustMax":0,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":32,"clockId":"0x507c6fffff1fb484","boardLabel":"","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":0,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":0,"direction":"","prio":0,"state":"","phaseOffsetPs":0},"pinParentPin":{"parentId":20,"parentState":"disconnected"},"phaseAdjustMin":0,"phaseAdjustMax":0,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:35.556823556Z","id":33,"clockId":"0x507c6fffff1fb484","boardLabel":"","panelLabel":"","packageLabel":"","type":"synce-eth-port","frequency":0,"frequencySupported":{"frequencyMin":0,"frequencyMax":0},"capabilities":"state-can-change","pinParentDevice":{"parentId":0,"direction":"","prio":0,"state":"","phaseOffsetPs":0},"pinParentPin":{"parentId":20,"parentState":"disconnected"},"phaseAdjustMin":0,"phaseAdjustMax":0,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
```
#
```bash
sh-5.1§ dpll-cli monitor 
{"timestamp":"2024-03-04T13:18:45.463926946Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":-140.83},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:45.501497332Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":1819.96},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:45.554733964Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":-140.83},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:45.601119257Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":1819.96},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:46.485397444Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":178.72},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:46.553495107Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":-1552.09},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:46.591702689Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":178.72},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:46.641055384Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":-1552.09},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:47.488435035Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":-179.41},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:47.550756174Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":3658},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:47.607000476Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":-179.41},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:18:47.655550104Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":3658},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
^C
sh-5.1§

```

## Run on any host
```bash
§ [root@cnfde22 core]# podman run --privileged --network=host quay.io/vgrinber/tools:dpll  /usr/local/bin/dpll-cli monitor
{"timestamp":"2024-03-04T13:52:59.486398726Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":621.42},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:52:59.539147036Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":-560.98},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:52:59.584290007Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":621.42},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:52:59.647235769Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":-560.98},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:53:00.46577693Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":341.61},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:53:00.527902936Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":-2477.02},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:53:00.581938604Z","id":21,"clockId":"0x507c6fffff1fb484","boardLabel":"SMA1","panelLabel":"","packageLabel":"","type":"ext","frequency":1,"frequencySupported":{"frequencyMin":10000000,"frequencyMax":10000000},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":3,"direction":"input","prio":3,"state":"connected","phaseOffsetPs":341.61},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
{"timestamp":"2024-03-04T13:53:00.645398005Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":-2477.02},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
^C

```

### Monitor raw data

```bash
[core@cnfde22 ~]$ podman run --network=host quay.io/vgrinber/tools:dpll  /usr/local/bin/dpll-cli monitor -r
2024/04/17 07:26:56 0dff83020102ff840001ff82000013ff81060101074d65737361676501ff820000002cff850301010648656164657201ff860001020107436f6d6d616e64010600010756657273696f6e0106000000ffe6ff840001ffe00c010000080001000600000008000300696365000c000500e8b41fffff6f7c500e000600474e53532d31505053000000080009000500000008001100060000000c000b0001000000000000001c000c800c000d0001000000000000000c000e00010000000000000008001400adbeffff08001500534100000800160000000000300012800800020000000000080010000100000008000f000000000008000a00010000000c00170088c637b2e3c30100300012800800020001000000080010000100000008000f000000000008000a00010000000c0017005cd6180000000000
{"timestamp":"2024-04-17T07:26:56.51143012Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":1627.74},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
2024/04/17 07:26:56 0dff83020102ff840001ff82000013ff81060101074d65737361676501ff820000002cff850301010648656164657201ff860001020107436f6d6d616e64010600010756657273696f6e0106000000ffe6ff840001ffe00c010000080001000600000008000300696365000c000500e8b41fffff6f7c500e000600474e53532d31505053000000080009000500000008001100060000000c000b0001000000000000001c000c800c000d0001000000000000000c000e00010000000000000008001400adbeffff08001500534100000800160000000000300012800800020000000000080010000100000008000f000000000008000a00010000000c00170088c637b2e3c30100300012800800020001000000080010000100000008000f000000000008000a00010000000c0017005cd6180000000000
{"timestamp":"2024-04-17T07:26:56.562395714Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":1627.74},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}
2024/04/17 07:26:57 0dff83020102ff840001ff82000013ff81060101074d65737361676501ff820000002cff850301010648656164657201ff860001020107436f6d6d616e64010600010756657273696f6e0106000000ffe6ff840001ffe00c010000080001000600000008000300696365000c000500e8b41fffff6f7c500e000600474e53532d31505053000000080009000500000008001100060000000c000b0001000000000000001c000c800c000d0001000000000000000c000e00010000000000000008001400adbeffff08001500534100000800160000000000300012800800020000000000080010000100000008000f000000000008000a00010000000c0017006876fdb1e3c30100300012800800020001000000080010000100000008000f000000000008000a00010000000c0017005086deffffffffff
{"timestamp":"2024-04-17T07:26:57.435248556Z","id":6,"clockId":"0x507c6fffff1fb4e8","boardLabel":"GNSS-1PPS","panelLabel":"","packageLabel":"","type":"gnss","frequency":1,"frequencySupported":{"frequencyMin":1,"frequencyMax":1},"capabilities":"state-can-change,priority-can-change","pinParentDevice":{"parentId":1,"direction":"input","prio":0,"state":"connected","phaseOffsetPs":-2193.84},"pinParentPin":{"parentId":0,"parentState":""},"phaseAdjustMin":-16723,"phaseAdjustMax":16723,"phaseAdjust":0,"fractionalFrequencyOffset":0,"moduleName":"ice"}


```

