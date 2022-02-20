## `mos_lab` is a Family for `merOS-virt`


Based on **Debian**, **2 Targets** ( VMs ) comprised of a bridged <br> network configuration, provides a ***Virtual, OS analysis lab***.
___

### `mos_lab-panther` :: Acts as the Workstation- <br>

Bridged with `mos_lab-target`, <br> 
and equiped with a multitude of pen-testing applications,<br> 
it allows for a machine capable of securely analyzing an image (`target`).<br>
___

### `mos_lab-tagert` :: Acts as the Victim Machine- <br>

Bridged with `mos_lab-panther`, <br> 
can be a pre-build .iso, .qcow2 or .raw machine.<br> 
**Vulnhub.com is a great resource for such machines.** <br>

___

Networking is provided by `libvirt` (@ `libvirt/net_*`) <br>
and routes all traffic in the isolated network.

---

Connection to the `panther` ( `mos_lab-panther` ) can be achieved with `-c|--connect` and/ or `--run` `mos_lab-panther`<br>
*ex.* `meros --run mos_lab-panther konsole`

Internet access is not provided- <br>
___

Configuration files exploration is **encouraged**,
since by design- <br> 
The **Configuration-Tree is optimized for Customization.**

---

## For more information check [merOS-virt](https://github.com/AranAilbhe/merOS-virt) on Github
