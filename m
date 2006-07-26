From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: aic94xx: Test results for 3 level cascading expander
Date: Wed, 26 Jul 2006 15:22:45 -0700
Message-ID: <1153952565.5456.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:1258 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751798AbWGZWXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jul 2006 18:23:31 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6QMNVoD011344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2006 18:23:31 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6QMNUlH180576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2006 16:23:31 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6QMNUQA025096
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2006 16:23:30 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi James,

Here is the boot dump for an x260 with a 3 level cascading expander configuration using the aic94xx driver.  

HBA [94xx]-->expander [Vitesse]-->expander [Vitesse]-->expander [internal]--->end devices [4 disks]

tree /sys/class/scsi_host/host0/device output is also attached.

Regards,

Alexis


----------------
Boot dump
----------------
Creating devices
Loading scsi_transport_sas
Loading scsi_transport_sas_domain
Loading aic94xx
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 193
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:01:02.0
scsi0 : aic94xx
aic94xx: BIOS present (1,1), 1545
aic94xx: ue num:4, ue size:88
aic94xx: 1Found FLASH(8) manuf:1, dev_id:0xda, sec_prot:0
aic94xx: manuf sect SAS_ADDR 5005076a011061c0
aic94xx: manuf sect PCBA SN
aic94xx: ms: num_phy_desc: 8
aic94xx: ms: phy0: ENEBLEABLE
aic94xx: ms: phy1: ENEBLEABLE
aic94xx: ms: phy2: ENEBLEABLE
aic94xx: ms: phy3: ENEBLEABLE
aic94xx: ms: phy4: ENEBLEABLE
aic94xx: ms: phy5: ENEBLEABLE
aic94xx: ms: phy6: ENEBLEABLE
aic94xx: ms: phy7: ENEBLEABLE
aic94xx: ms: max_phys:0x8, num_phys:0x8
aic94xx: ms: enabled_phys:0xff
aic94xx: ctrla: phy0: sas_addr: 5005076a011061c0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 5005076a011061c0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 5005076a011061c0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 5005076a011061c0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 5005076a011061c0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 5005076a011061c0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 5005076a011061c0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 5005076a011061c0, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 5005076a011061c0
aic94xx: setting phy1 addr to 5005076a011061c0
aic94xx: setting phy2 addr to 5005076a011061c0
aic94xx: setting phy3 addr to 5005076a011061c0
aic94xx: setting phy4 addr to 5005076a011061c0
aic94xx: setting phy5 addr to 5005076a011061c0
aic94xx: setting phy6 addr to 5005076a011061c0
aic94xx: setting phy7 addr to 5005076a011061c0
aic94xx: num_edbs:21
aic94xx: num_escbs:3
aic94xx: using sequencer Razor_10a1
aic94xx: downloading CSEQ...
aic94xx: dma-ing 8192 bytes
aic94xx: verified 8192 bytes, passed
aic94xx: downloading LSEQs...
aic94xx: dma-ing 14336 bytes
aic94xx: LSEQ0 verified 14336 bytes, passed
aic94xx: LSEQ1 verified 14336 bytes, passed
aic94xx: LSEQ2 verified 14336 bytes, passed
aic94xx: LSEQ3 verified 14336 bytes, passed
aic94xx: LSEQ4 verified 14336 bytes, passed
aic94xx: LSEQ5 verified 14336 bytes, passed
aic94xx: LSEQ6 verified 14336 bytes, passed
aic94xx: LSEQ7 verified 14336 bytes, passed
aic94xx: max_scbs:446
aic94xx: first_scb_site_no:0x20
aic94xx: last_scb_site_no:0x1fe
aic94xx: First SCB dma_handle: 0x227000
aic94xx: device 0000:01:02.0: SAS addr 5005076a011061c0, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1545
aic94xx: posting 3 escbs
aic94xx: escbs posted
aic94xx: posting 8 control phy scbs
aic94xx: enabled phys
aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy0, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 1c 10
aic94xx: 10: 71 60 00 00
aic94xx: 14: 08 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy1, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 1c 10
aic94xx: 10: 71 60 00 00
aic94xx: 14: 09 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
sas: phy0 added to port0, phy_mask:0x1
sas: phy1 matched wide port0
sas: phy1 added to port0, phy_mask:0x3
sas: DOING DISCOVERY on port 0, pid:1840
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 1c 10
aic94xx: 10: 71 60 00 00
aic94xx: 14: 0a 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy3, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 1c 10
aic94xx: 10: 71 60 00 00
aic94xx: 14: 0b 00 00 00
aic94xx: 18: 00 00 00 00
sas: ex 50001c1071600000 phy00:T attached: 50001c1716004000
sas: ex 50001c1071600000 phy01:T attached: 50001c1716004000
sas: ex 50001c1071600000 phy02:T attached: 50001c1716004000
sas: ex 50001c1071600000 phy03:T attached: 50001c1716004000
sas: ex 50001c1071600000 phy04:T attached: 0000000000000000
sas: ex 50001c1071600000 phy05:T attached: 0000000000000000
sas: ex 50001c1071600000 phy06:T attached: 0000000000000000
sas: ex 50001c1071600000 phy07:T attached: 0000000000000000
sas: ex 50001c1071600000 phy08:S attached: 5005076a011061c0
sas: ex 50001c1071600000 phy09:S attached: 5005076a011061c0
sas: ex 50001c1071600000 phy10:S attached: 5005076a011061c0
sas: ex 50001c1071600000 phy11:S attached: 5005076a011061c0
sas: ex 50001c1071600000 phy12:D attached: 50001c107160000d
sas: ex 50001c1716004000 phy00:T attached: 5005076a00000a40
sas: ex 50001c1716004000 phy01:T attached: 5005076a00000a40
sas: ex 50001c1716004000 phy02:T attached: 5005076a00000a40
sas: ex 50001c1716004000 phy03:T attached: 5005076a00000a40
sas: ex 50001c1716004000 phy04:T attached: 0000000000000000
sas: ex 50001c1716004000 phy05:T attached: 0000000000000000
sas: ex 50001c1716004000 phy06:T attached: 0000000000000000
sas: ex 50001c1716004000 phy07:T attached: 0000000000000000
sas: ex 50001c1716004000 phy08:S attached: 50001c1071600000
sas: ex 50001c1716004000 phy09:S attached: 50001c1071600000
sas: ex 50001c1716004000 phy10:S attached: 50001c1071600000
sas: ex 50001c1716004000 phy11:S attached: 50001c1071600000
sas: ex 50001c1716004000 phy12:D attached: 50001c171600400d
  Vendor: VITESSE   Model: VSC7160 Eval Brd  Rev: 4
  Type:   Enclosure                          ANSI SCSI revision: 03
sas: device 50001c107160000d, LUN 0 doesn't support TCQ
sas: ex 5005076a00000a40 phy00:T attached: 50010b9000021585
sas: ex 5005076a00000a40 phy01:T attached: 50010b9000021575
sas: ex 5005076a00000a40 phy02:T attached: 50010b900004b87e
sas: ex 5005076a00000a40 phy03:S attached: 50001c1716004000
sas: ex 5005076a00000a40 phy04:S attached: 50001c1716004000
sas: ex 5005076a00000a40 phy05:T attached: 0000000000000000
sas: ex 5005076a00000a40 phy06:T attached: 0000000000000000
sas: ex 5005076a00000a40 phy07:S attached: 50001c1716004000
sas: ex 5005076a00000a40 phy08:S attached: 50001c1716004000
sas: ex 5005076a00000a40 phy09:T attached: 50010b9000004f45
sas: ex 5005076a00000a40 phy10:T attached: 0000000000000000
sas: ex 5005076a00000a40 phy11:T attached: 0000000000000000
sas: ex 5005076a00000a40 phy12:D attached: 5005076a00000a4d
  Vendor: VITESSE   Model: VSC7160 Eval Brd  Rev: 4
  Type:   Enclosure                          ANSI SCSI revision: 03
sas: device 50001c171600400d, LUN 0 doesn't support TCQ
  Vendor: IBM-ESXS  Model: BBA036C3ESTT0Z N  Rev: BH0C
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
 sda: sda1 sda2 sda3 sda4 < sda5 >
sd 0:0:2:0: Attached scsi disk sda
  Vendor: IBM-ESXS  Model: BBA036C3ESTT0Z N  Rev: BH0C
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
sdb: Write Protect is off
SCSI device sdb: drive cache: write through w/ FUA
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
sdb: Write Protect is off
SCSI device sdb: drive cache: write through w/ FUA
 sdb: sdb1
sd 0:0:3:0: Attached scsi disk sdb
  Vendor: IBM-ESXS  Model: GNA073C3ESTT0Z N  Rev: BH08
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 143374000 512-byte hdwr sectors (73407 MB)
sdc: Write Protect is off
SCSI device sdc: drive cache: write through w/ FUA
SCSI device sdc: 143374000 512-byte hdwr sectors (73407 MB)
sdc: Write Protect is off
SCSI device sdc: drive cache: write through w/ FUA
 sdc: sdc1 sdc2 sdc3 sdc4 < >
sd 0:0:4:0: Attached scsi disk sdc
  Vendor: IBM-ESXS  Model: BBA036C3ESTT0Z N  Rev: BH08
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdd: 71096640 512-byte hdwr sectors (36401 MB)
sdd: Write Protect is off
SCSI device sdd: drive cache: write back w/ FUA
SCSI device sdd: 71096640 512-byte hdwr sectors (36401 MB)
sdd: Write Protect is off
SCSI device sdd: drive cache: write back w/ FUA
 sdd: sdd1 sdd2 sdd3
sd 0:0:5:0: Attached scsi disk sdd
  Vendor: IBM-ESXS  Model: VSC7160           Rev: 0.07
  Type:   Enclosure                          ANSI SCSI revision: 03
sas: device 5005076a00000a4d, LUN 0 doesn't support TCQ
sas: DONE DISCOVERY on port 0, pid:1840, result:0
sas: phy2 matched wide port0
sas: phy2 added to port0, phy_mask:0x7
sas: phy3 matched wide port0
sas: phy3 added to port0, phy_mask:0xf

---------------------------------------
tree /sys/class/scsi_host/host0/device
---------------------------------------

/sys/class/scsi_host/host0 # tree device
device
|-- phy-0:0
|   |-- port -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:0 -> ../../../../../class/sas_phy/phy-0:0
|   `-- uevent
|-- phy-0:1
|   |-- port -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:1 -> ../../../../../class/sas_phy/phy-0:1
|   `-- uevent
|-- phy-0:2
|   |-- port -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:2 -> ../../../../../class/sas_phy/phy-0:2
|   `-- uevent
|-- phy-0:3
|   |-- port -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:3 -> ../../../../../class/sas_phy/phy-0:3
|   `-- uevent
|-- phy-0:4
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:4 -> ../../../../../class/sas_phy/phy-0:4
|   `-- uevent
|-- phy-0:5
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:5 -> ../../../../../class/sas_phy/phy-0:5
|   `-- uevent
|-- phy-0:6
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:6 -> ../../../../../class/sas_phy/phy-0:6
|   `-- uevent
|-- phy-0:7
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:7 -> ../../../../../class/sas_phy/phy-0:7
|   `-- uevent
|-- port-0:0
|   |-- expander-0:0
|   |   |-- phy-0:0:0
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:0 -> ../../../../../../../class/sas_phy/phy-0:0:0
|   |   |   `-- uevent
|   |   |-- phy-0:0:1
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:1 -> ../../../../../../../class/sas_phy/phy-0:0:1
|   |   |   `-- uevent
|   |   |-- phy-0:0:10
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:8
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:10 -> ../../../../../../../class/sas_phy/phy-0:0:10
|   |   |   `-- uevent
|   |   |-- phy-0:0:11
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:8
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:11 -> ../../../../../../../class/sas_phy/phy-0:0:11
|   |   |   `-- uevent
|   |   |-- phy-0:0:12
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:12
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:12 -> ../../../../../../../class/sas_phy/phy-0:0:12
|   |   |   `-- uevent
|   |   |-- phy-0:0:2
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:2 -> ../../../../../../../class/sas_phy/phy-0:0:2
|   |   |   `-- uevent
|   |   |-- phy-0:0:3
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:3 -> ../../../../../../../class/sas_phy/phy-0:0:3
|   |   |   `-- uevent
|   |   |-- phy-0:0:4
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:4 -> ../../../../../../../class/sas_phy/phy-0:0:4
|   |   |   `-- uevent
|   |   |-- phy-0:0:5
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:5 -> ../../../../../../../class/sas_phy/phy-0:0:5
|   |   |   `-- uevent
|   |   |-- phy-0:0:6
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:6 -> ../../../../../../../class/sas_phy/phy-0:0:6
|   |   |   `-- uevent
|   |   |-- phy-0:0:7
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:7 -> ../../../../../../../class/sas_phy/phy-0:0:7
|   |   |   `-- uevent
|   |   |-- phy-0:0:8
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:8
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:8 -> ../../../../../../../class/sas_phy/phy-0:0:8
|   |   |   `-- uevent
|   |   |-- phy-0:0:9
|   |   |   |-- port -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:8
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:9 -> ../../../../../../../class/sas_phy/phy-0:0:9
|   |   |   `-- uevent
|   |   |-- port-0:0:0
|   |   |   |-- expander-0:1
|   |   |   |   |-- phy-0:1:0
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:0 -> ../../../../../../../../../class/sas_phy/phy-0:1:0
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:1
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:1 -> ../../../../../../../../../class/sas_phy/phy-0:1:1
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:10
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:8
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:10 -> ../../../../../../../../../class/sas_phy/phy-0:1:10
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:11
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:8
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:11 -> ../../../../../../../../../class/sas_phy/phy-0:1:11
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:12
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:12
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:12 -> ../../../../../../../../../class/sas_phy/phy-0:1:12
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:2
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:2 -> ../../../../../../../../../class/sas_phy/phy-0:1:2
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:3
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:3 -> ../../../../../../../../../class/sas_phy/phy-0:1:3
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:4
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:4 -> ../../../../../../../../../class/sas_phy/phy-0:1:4
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:5
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:5 -> ../../../../../../../../../class/sas_phy/phy-0:1:5
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:6
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:6 -> ../../../../../../../../../class/sas_phy/phy-0:1:6
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:7
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:7 -> ../../../../../../../../../class/sas_phy/phy-0:1:7
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:8
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:8
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:8 -> ../../../../../../../../../class/sas_phy/phy-0:1:8
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:9
|   |   |   |   |   |-- port -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:8
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:9 -> ../../../../../../../../../class/sas_phy/phy-0:1:9
|   |   |   |   |   `-- uevent
|   |   |   |   |-- port-0:1:0
|   |   |   |   |   |-- expander-0:2
|   |   |   |   |   |   |-- phy-0:2:0
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:0
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:0 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:0
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:1
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:1
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:1 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:1
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:10
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:10 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:10
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:11
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:11 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:11
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:12
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:12
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:12 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:12
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:2
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:2
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:2 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:2
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:3
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:3
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:3 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:3
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:4
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:3
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:4 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:4
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:5
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:5 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:5
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:6
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:6 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:6
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:7
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:3
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:7 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:7
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:8
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:3
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:8 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:8
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- phy-0:2:9
|   |   |   |   |   |   |   |-- port -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/port-0:2:9
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_phy:phy-0:2:9 -> ../../../../../../../../../../../class/sas_phy/phy-0:2:9
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- port-0:2:0
|   |   |   |   |   |   |   |-- end_device-0:2:0
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- sas_device:end_device-0:2:0 -> ../../../../../../../../../../../../class/sas_device/end_device-0:2:0
|   |   |   |   |   |   |   |   |-- sas_end_device:end_device-0:2:0 -> ../../../../../../../../../../../../class/sas_end_device/end_device-0:2:0
|   |   |   |   |   |   |   |   |-- target0:0:2
|   |   |   |   |   |   |   |   |   |-- 0:0:2:0
|   |   |   |   |   |   |   |   |   |   |-- block:sda -> ../../../../../../../../../../../../../../block/sda
|   |   |   |   |   |   |   |   |   |   |-- bus -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |   |   |-- driver -> ../../../../../../../../../../../../../../bus/scsi/drivers/sd
|   |   |   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |   |   |-- scsi_device:0:0:2:0 -> ../../../../../../../../../../../../../../class/scsi_device/0:0:2:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_disk:0:0:2:0 -> ../../../../../../../../../../../../../../class/scsi_disk/0:0:2:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |-- subsystem -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |-- phy-0:2:0 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:0
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_port:port-0:2:0 -> ../../../../../../../../../../../class/sas_port/port-0:2:0
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- port-0:2:1
|   |   |   |   |   |   |   |-- end_device-0:2:1
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- sas_device:end_device-0:2:1 -> ../../../../../../../../../../../../class/sas_device/end_device-0:2:1
|   |   |   |   |   |   |   |   |-- sas_end_device:end_device-0:2:1 -> ../../../../../../../../../../../../class/sas_end_device/end_device-0:2:1
|   |   |   |   |   |   |   |   |-- target0:0:3
|   |   |   |   |   |   |   |   |   |-- 0:0:3:0
|   |   |   |   |   |   |   |   |   |   |-- block:sdb -> ../../../../../../../../../../../../../../block/sdb
|   |   |   |   |   |   |   |   |   |   |-- bus -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |   |   |-- driver -> ../../../../../../../../../../../../../../bus/scsi/drivers/sd
|   |   |   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |   |   |-- scsi_device:0:0:3:0 -> ../../../../../../../../../../../../../../class/scsi_device/0:0:3:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_disk:0:0:3:0 -> ../../../../../../../../../../../../../../class/scsi_disk/0:0:3:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |-- subsystem -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |-- phy-0:2:1 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:1
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_port:port-0:2:1 -> ../../../../../../../../../../../class/sas_port/port-0:2:1
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- port-0:2:12
|   |   |   |   |   |   |   |-- end_device-0:2:12
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- sas_device:end_device-0:2:12 -> ../../../../../../../../../../../../class/sas_device/end_device-0:2:12
|   |   |   |   |   |   |   |   |-- sas_end_device:end_device-0:2:12 -> ../../../../../../../../../../../../class/sas_end_device/end_device-0:2:12
|   |   |   |   |   |   |   |   |-- target0:0:6
|   |   |   |   |   |   |   |   |   |-- 0:0:6:0
|   |   |   |   |   |   |   |   |   |   |-- bus -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |   |   |-- scsi_device:0:0:6:0 -> ../../../../../../../../../../../../../../class/scsi_device/0:0:6:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |-- subsystem -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |-- phy-0:2:12 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:12
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_port:port-0:2:12 -> ../../../../../../../../../../../class/sas_port/port-0:2:12
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- port-0:2:2
|   |   |   |   |   |   |   |-- end_device-0:2:2
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- sas_device:end_device-0:2:2 -> ../../../../../../../../../../../../class/sas_device/end_device-0:2:2
|   |   |   |   |   |   |   |   |-- sas_end_device:end_device-0:2:2 -> ../../../../../../../../../../../../class/sas_end_device/end_device-0:2:2
|   |   |   |   |   |   |   |   |-- target0:0:4
|   |   |   |   |   |   |   |   |   |-- 0:0:4:0
|   |   |   |   |   |   |   |   |   |   |-- block:sdc -> ../../../../../../../../../../../../../../block/sdc
|   |   |   |   |   |   |   |   |   |   |-- bus -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |   |   |-- driver -> ../../../../../../../../../../../../../../bus/scsi/drivers/sd
|   |   |   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |   |   |-- scsi_device:0:0:4:0 -> ../../../../../../../../../../../../../../class/scsi_device/0:0:4:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_disk:0:0:4:0 -> ../../../../../../../../../../../../../../class/scsi_disk/0:0:4:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |-- subsystem -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |-- phy-0:2:2 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:2
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_port:port-0:2:2 -> ../../../../../../../../../../../class/sas_port/port-0:2:2
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- port-0:2:3
|   |   |   |   |   |   |   |-- expander-0:1 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1
|   |   |   |   |   |   |   |-- phy-0:2:3 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:3
|   |   |   |   |   |   |   |-- phy-0:2:4 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:4
|   |   |   |   |   |   |   |-- phy-0:2:7 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:7
|   |   |   |   |   |   |   |-- phy-0:2:8 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:8
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_port:port-0:2:3 -> ../../../../../../../../../../../class/sas_port/port-0:2:3
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- port-0:2:9
|   |   |   |   |   |   |   |-- end_device-0:2:9
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- sas_device:end_device-0:2:9 -> ../../../../../../../../../../../../class/sas_device/end_device-0:2:9
|   |   |   |   |   |   |   |   |-- sas_end_device:end_device-0:2:9 -> ../../../../../../../../../../../../class/sas_end_device/end_device-0:2:9
|   |   |   |   |   |   |   |   |-- target0:0:5
|   |   |   |   |   |   |   |   |   |-- 0:0:5:0
|   |   |   |   |   |   |   |   |   |   |-- block:sdd -> ../../../../../../../../../../../../../../block/sdd
|   |   |   |   |   |   |   |   |   |   |-- bus -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |   |   |-- driver -> ../../../../../../../../../../../../../../bus/scsi/drivers/sd
|   |   |   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |   |   |-- scsi_device:0:0:5:0 -> ../../../../../../../../../../../../../../class/scsi_device/0:0:5:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_disk:0:0:5:0 -> ../../../../../../../../../../../../../../class/scsi_disk/0:0:5:0
|   |   |   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   |-- subsystem -> ../../../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |   |-- phy-0:2:9 -> ../../../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0/expander-0:2/phy-0:2:9
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |-- sas_port:port-0:2:9 -> ../../../../../../../../../../../class/sas_port/port-0:2:9
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- sas_device:expander-0:2 -> ../../../../../../../../../../class/sas_device/expander-0:2
|   |   |   |   |   |   |-- sas_expander:expander-0:2 -> ../../../../../../../../../../class/sas_expander/expander-0:2
|   |   |   |   |   |   `-- uevent
|   |   |   |   |   |-- phy-0:1:0 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:0|   |   |   |   |   |-- phy-0:1:1 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:1|   |   |   |   |   |-- phy-0:1:2 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:2|   |   |   |   |   |-- phy-0:1:3 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:3|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_port:port-0:1:0 -> ../../../../../../../../../class/sas_port/port-0:1:0
|   |   |   |   |   `-- uevent
|   |   |   |   |-- port-0:1:12
|   |   |   |   |   |-- end_device-0:1:12
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- sas_device:end_device-0:1:12 -> ../../../../../../../../../../class/sas_device/end_device-0:1:12
|   |   |   |   |   |   |-- sas_end_device:end_device-0:1:12 -> ../../../../../../../../../../class/sas_end_device/end_device-0:1:12
|   |   |   |   |   |   |-- target0:0:1
|   |   |   |   |   |   |   |-- 0:0:1:0
|   |   |   |   |   |   |   |   |-- bus -> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |-- scsi_device:0:0:1:0 -> ../../../../../../../../../../../../class/scsi_device/0:0:1:0
|   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |-- subsystem -> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   `-- uevent
|   |   |   |   |   |-- phy-0:1:12 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:12
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_port:port-0:1:12 -> ../../../../../../../../../class/sas_port/port-0:1:12
|   |   |   |   |   `-- uevent
|   |   |   |   |-- port-0:1:8
|   |   |   |   |   |-- expander-0:0 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0
|   |   |   |   |   |-- phy-0:1:10 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:10
|   |   |   |   |   |-- phy-0:1:11 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:11
|   |   |   |   |   |-- phy-0:1:8 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:8|   |   |   |   |   |-- phy-0:1:9 -> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:9|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_port:port-0:1:8 -> ../../../../../../../../../class/sas_port/port-0:1:8
|   |   |   |   |   `-- uevent
|   |   |   |   |-- power
|   |   |   |   |   |-- state
|   |   |   |   |   `-- wakeup
|   |   |   |   |-- sas_device:expander-0:1 -> ../../../../../../../../class/sas_device/expander-0:1
|   |   |   |   |-- sas_expander:expander-0:1 -> ../../../../../../../../class/sas_expander/expander-0:1
|   |   |   |   `-- uevent
|   |   |   |-- phy-0:0:0 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:0
|   |   |   |-- phy-0:0:1 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:1
|   |   |   |-- phy-0:0:2 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:2
|   |   |   |-- phy-0:0:3 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:3
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_port:port-0:0:0 -> ../../../../../../../class/sas_port/port-0:0:0
|   |   |   `-- uevent
|   |   |-- port-0:0:12
|   |   |   |-- end_device-0:0:12
|   |   |   |   |-- power
|   |   |   |   |   |-- state
|   |   |   |   |   `-- wakeup
|   |   |   |   |-- sas_device:end_device-0:0:12 -> ../../../../../../../../class/sas_device/end_device-0:0:12
|   |   |   |   |-- sas_end_device:end_device-0:0:12 -> ../../../../../../../../class/sas_end_device/end_device-0:0:12
|   |   |   |   |-- target0:0:0
|   |   |   |   |   |-- 0:0:0:0
|   |   |   |   |   |   |-- bus -> ../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |-- model
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |-- scsi_device:0:0:0:0 -> ../../../../../../../../../../class/scsi_device/0:0:0:0
|   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   |-- subsystem -> ../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |-- type
|   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   `-- vendor
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   `-- uevent
|   |   |   |   `-- uevent
|   |   |   |-- phy-0:0:12 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:12
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_port:port-0:0:12 -> ../../../../../../../class/sas_port/port-0:0:12
|   |   |   `-- uevent
|   |   |-- port-0:0:8
|   |   |   |-- host0 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0
|   |   |   |-- phy-0:0:10 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:10
|   |   |   |-- phy-0:0:11 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:11
|   |   |   |-- phy-0:0:8 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:8
|   |   |   |-- phy-0:0:9 -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:9
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_port:port-0:0:8 -> ../../../../../../../class/sas_port/port-0:0:8
|   |   |   `-- uevent
|   |   |-- power
|   |   |   |-- state
|   |   |   `-- wakeup
|   |   |-- sas_device:expander-0:0 -> ../../../../../../class/sas_device/expander-0:0
|   |   |-- sas_expander:expander-0:0 -> ../../../../../../class/sas_expander/expander-0:0
|   |   `-- uevent
|   |-- phy-0:0 -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:0
|   |-- phy-0:1 -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:1
|   |-- phy-0:2 -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:2
|   |-- phy-0:3 -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:3
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_port:port-0:0 -> ../../../../../class/sas_port/port-0:0
|   `-- uevent
|-- power
|   |-- state
|   `-- wakeup
|-- sas_host:host0 -> ../../../../class/sas_host/host0
|-- scsi_host:host0 -> ../../../../class/scsi_host/host0
`-- uevent




