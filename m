From: Richard Gooch <rgooch@ras.ucalgary.ca>
Subject: Problems with 2.4.19+ and Arena RAID5
Date: Tue, 22 Oct 2002 01:01:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210220701.g9M71TS23819@vindaloo.ras.ucalgary.ca>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  Hi, all. I've recently plugged in an old Arena RAID5 box into an
Athalon box running 2.4.19 and 2.4.20-pre?, and I get SCSI bus stalls
and hangups when accessing the Arena after a minute or so. Has anyone
seen this kind of behaviour? Any suggestions? Is this fixable (i.e. is
it a software problem)? I've appended the kernel messages when things
go wrong.

The boot messages are:

SCSI subsystem driver Revision: 1.00
PCI: Found IRQ 10 for device 00:0f.0
PCI: Sharing IRQ 10 with 00:07.3
PCI: Sharing IRQ 10 with 00:07.2
sym.0.15.0: setting PCI_COMMAND_PARITY...
sym0: <895> rev 0x1 on pci bus 0 device 15 function 0 irq 10
sym0: Tekram NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.17a
  Vendor: IBM       Model: DNES-309170W      Rev: SA30
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
  Vendor: IBM       Model: DGHS18U           Rev: 03E0
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
  Vendor:           Model: DGRS              Rev: 0210
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:3: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: DMVS36V           Rev: 02B0
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:4: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: DMVS36V           Rev: 0250
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: Arena     Model:                   Rev:     
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: IBM       Model: DNES-309170W      Rev: SA30
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:0:0: tagged command queuing enabled, command queue depth 16.
sym0:1:0: tagged command queuing enabled, command queue depth 16.
sym0:2:0: tagged command queuing enabled, command queue depth 16.
sym0:3:0: tagged command queuing enabled, command queue depth 16.
sym0:4:0: tagged command queuing enabled, command queue depth 16.
sym0:6:0: tagged command queuing enabled, command queue depth 16.
sym0:8:0: tagged command queuing enabled, command queue depth 16.
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
Attached scsi disk sdd at scsi0, channel 0, id 3, lun 0
Attached scsi disk sde at scsi0, channel 0, id 4, lun 0
Attached scsi disk sdf at scsi0, channel 0, id 6, lun 0
Attached scsi disk sdg at scsi0, channel 0, id 8, lun 0
sym0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sda: 17916240 512-byte hdwr sectors (9173 MB)
 /dev/scsi/host0/bus0/target0/lun0: p1 p2 p3 p4 < p5 p6 p7 >
SCSI device sdb: 35843670 512-byte hdwr sectors (18352 MB)
 /dev/scsi/host0/bus0/target1/lun0: p1 p2
SCSI device sdc: 35843670 512-byte hdwr sectors (18352 MB)
 /dev/scsi/host0/bus0/target2/lun0: p1 p2
SCSI device sdd: 71687340 512-byte hdwr sectors (36704 MB)
 /dev/scsi/host0/bus0/target3/lun0: p1
SCSI device sde: 71687340 512-byte hdwr sectors (36704 MB)
 /dev/scsi/host0/bus0/target4/lun0: p1
sym0:6: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 16)
SCSI device sdf: 141123584 512-byte hdwr sectors (72255 MB)
 /dev/scsi/host0/bus0/target6/lun0: p1
sym0:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sdg: 17916240 512-byte hdwr sectors (9173 MB)
 /dev/scsi/host0/bus0/target8/lun0: p1 p2 p3 p4 < p5 p6 p7 p8 p9 >

				Regards,

					Richard....
Permanent: rgooch@atnf.csiro.au
Current:   rgooch@ras.ucalgary.ca
===============================================================================
Oct 22 00:44:18 bbox kernel: sym0:0:0: ABORT operation started. 
Oct 22 00:44:23 bbox kernel: sym0:0:0: ABORT operation timed-out. 
Oct 22 00:44:23 bbox kernel: sym0:0:0: ABORT operation started. 
Oct 22 00:44:28 bbox kernel: sym0:0:0: ABORT operation timed-out. 
Oct 22 00:44:28 bbox kernel: sym0:0:0: ABORT operation started. 
Oct 22 00:44:33 bbox kernel: sym0:0:0: ABORT operation timed-out. 
Oct 22 00:44:33 bbox kernel: sym0:0:0: ABORT operation started. 
Oct 22 00:44:38 bbox kernel: sym0:0:0: ABORT operation timed-out. 
Oct 22 00:44:38 bbox kernel: sym0:0:0: ABORT operation started. 
Oct 22 00:44:43 bbox kernel: sym0:0:0: ABORT operation timed-out. 
Oct 22 00:44:43 bbox kernel: sym0:6:0: ABORT operation started. 
Oct 22 00:44:48 bbox kernel: sym0:6:0: ABORT operation timed-out. 
Oct 22 00:44:48 bbox kernel: sym0:6:0: ABORT operation started. 
Oct 22 00:44:53 bbox kernel: sym0:6:0: ABORT operation timed-out. 
Oct 22 00:44:53 bbox kernel: sym0:0:0: DEVICE RESET operation started. 
Oct 22 00:44:58 bbox kernel: sym0:0:0: DEVICE RESET operation timed-out. 
Oct 22 00:44:58 bbox kernel: sym0:6:0: DEVICE RESET operation started. 
Oct 22 00:45:03 bbox kernel: sym0:6:0: DEVICE RESET operation timed-out. 
Oct 22 00:45:03 bbox kernel: sym0:0:0: BUS RESET operation started. 
Oct 22 00:45:03 bbox kernel: sym0: SCSI BUS reset detected. 
Oct 22 00:45:03 bbox kernel: sym0: SCSI BUS has been reset. 
Oct 22 00:45:03 bbox kernel: sym0:0:0: BUS RESET operation complete. 
