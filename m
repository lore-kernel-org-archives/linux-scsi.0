From: Reinhold Fischer <news4reini123@aon.at>
Subject: Unable to set hostid in sym53c8xx module
Date: Wed, 20 Oct 2004 09:31:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410200931.22069.news4reini123@aon.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from webhosting2.datakom.at ([195.3.109.36]:64668 "EHLO
	email.datakom.at") by vger.kernel.org with ESMTP id S270149AbUJTHbg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 03:31:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I have a problem with setting the hostid to something other than #7 in=20
the sym53c8xx module with kernel 2.6.8.1 on Debian GNU/Linux 3.1=20
(Sarge), see below.

With kernel 2.4.27 all works fine.

I found nothing about this problem on the web or in=20
newsgroups/mailinglists.

I also filed bug 3588 (http://bugzilla.kernel.org/show_bug.cgi?id=3D358=
8),=20
but no response until now.
Maybee a did something wrong.

I tried to set other module parameter for debug and verbose outbut, but=
=20
it seems, that the module will ignore all parameters.

Maybee the driver documentation is wrong.

Or I am to stupid to set the parameter with kernel 2.6.

--=20
Mit freundlichen Gr=FC=DFen,
Ing. Reinhold Fischer


# uname -a=20
Linux linux-cluster2 2.6.8-1-686 #1 Thu Oct 7 03:15:25 EDT 2004 i686=20
GNU/Linux=20
# modprobe -r sym53c8xx
# modprobe sym53c8xx sym53c8xx=3Dhostid:5
# dmesg | sed -n '/Synchronizing SCSI cache for disk sda:/,$p'
Synchronizing SCSI cache for disk sda:
sym0: detaching ...
sym0: resetting chip
sym1: detaching ...
sym1: resetting chip
sym0: <896> rev 0x7 at pci 0000:03:04.0 irq 10
sym0: using 64 bit DMA addressing
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi2 : sym-2.1.18j
scsi: unknown device type 12
  Vendor: Compaq    Model: CR3500            Rev: x2r-
  Type:   RAID                               ANSI SCSI revision: 02
sym0:2:0: tagged command queuing enabled, command queue depth 16.
scsi(2:0:2:0): Beginning Domain Validation
sym0:2: wide asynchronous.
sym0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
scsi(2:0:2:0): Domain Validation skipping write tests
scsi(2:0:2:0): Ending Domain Validation
  Vendor: Compaq    Model: CR3500            Rev: x2r-
  Type:   Direct-Access                      ANSI SCSI revision: 02
sym0:2:1: tagged command queuing enabled, command queue depth 16.
scsi(2:0:2:1): Beginning Domain Validation
sym0:2: asynchronous.
sym0:2: wide asynchronous.
sym0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
scsi(2:0:2:1): Domain Validation skipping write tests
scsi(2:0:2:1): Ending Domain Validation
SCSI device sda: 35553280 512-byte hdwr sectors (18203 MB)
SCSI device sda: drive cache: write back
 /dev/scsi/host2/bus0/target2/lun1: p1 p2 p3
Attached scsi disk sda at scsi2, channel 0, id 2, lun 1
scsi: unknown device type 12
  Vendor: Compaq    Model: CR3500            Rev: x2r-
  Type:   RAID                               ANSI SCSI revision: 02
sym0:3:0: tagged command queuing enabled, command queue depth 16.
scsi(2:0:3:0): Beginning Domain Validation
sym0:3: wide asynchronous.
sym0:3: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
scsi(2:0:3:0): Domain Validation skipping write tests
scsi(2:0:3:0): Ending Domain Validation
sym1: <896> rev 0x7 at pci 0000:03:04.1 irq 11
sym1: using 64 bit DMA addressing
sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi3 : sym-2.1.18j


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
