From: Lawrence MacIntyre <lpz@ornl.gov>
Subject: Adaptec 200S on kernel > 2.4.21 won't boot
Date: Tue, 25 Nov 2003 17:21:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069798868.2790.218.camel@nautique>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-AVzEnopktCjonALiiD2S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emroute2.cind.ornl.gov ([160.91.86.17]:43514 "EHLO
	emroute2.cind.ornl.gov") by vger.kernel.org with ESMTP
	id S263053AbTKYWVT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 17:21:19 -0500
Received: from emroute2.cind.ornl.gov (LOCALHOST [127.0.0.1])
 by emroute2.cind.ornl.gov (PMDF V6.2-X17 #30669)
 with ESMTP id <0HOX006LQI3H6P@emroute2.cind.ornl.gov> for
 linux-scsi@vger.kernel.org; Tue, 25 Nov 2003 17:21:17 -0500 (EST)
Received: from EXCHANGE.ornl.gov (exchange1.ornl.gov [160.91.1.20])
 by emroute2.cind.ornl.gov (PMDF V6.2-X17 #30669)
 with ESMTP id <0HOX005HKI380L@emroute2.cind.ornl.gov> for
 linux-scsi@vger.kernel.org; Tue, 25 Nov 2003 17:21:08 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-AVzEnopktCjonALiiD2S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi:

I have a dual Xeon with an Adaptec 200S zero-channel raid controller
running the 2.4.21 kernel.  I want to try a patch that requires
2.4.23-rc-1.  However, when I build the kernel, it won't boot.  I simply
took the .config from the 2.4.21 kernel and ran make oldconfig.  I have
tried this with 2.4.22 unpatched and patched to 2.4.23-rc1.  When the
2.4.21 machine boots, I get these messages:

SvrWks CSB5: IDE controller at PCI slot 00:0f.1
SvrWks CSB5: chipset revision 147
SvrWks CSB5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
hda: CDU5211, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: attached ide-cdrom driver.
hda: ATAPI 52X CD-ROM drive, 120kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.12
SCSI subsystem driver Revision: 1.00
Loading Adaptec I2O RAID: Version 2.4 Build 5
Detecting Adaptec I2O RAID controllers...
Adaptec I2O RAID controller 0 irq=3D18
     BAR0 f881b000 - size=3D 100000
     BAR1 f891c000 - size=3D 1000000
dpti: If you have a lot of devices this could take a few minutes.
dpti0: Reading the hardware resource table.
TID 008  Vendor: ADAPTEC      Device: AIC-7899     Rev: 00000001
TID 009  Vendor: ADAPTEC      Device: AIC-7899     Rev: 00000001
TID 517  Vendor: ADAPTEC R    Device: RAID-1       Rev: 380ED
scsi0 : Vendor: Adaptec  Model: 2000S            FW:380E
  Vendor: ADAPTEC   Model: RAID-1            Rev: 380E
  Type:   Direct-Access                      ANSI SCSI revision: 02
Red Hat/Adaptec aacraid driver, Jul 15 2003
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 71686144 512-byte hdwr sectors (36703 MB)
Partition check:
 sda: sda1 sda2 sda3
usb.c: registered new driver usbdevfs
usb.c: registered new driver hub
host/uhci.c: USB Universal Host Controller Interface driver v1.1
Initializing USB Mass Storage driver...
usb.c: registered new driver usb-storage
USB Mass Storage support registered.
I2O Core - (C) Copyright 1999 Red Hat Software
I2O: Event thread created as pid 13
Linux I2O PCI support (c) 1999 Red Hat Software.
i2o: Checking for PCI I2O controllers...
I2O configuration manager v 0.04.
  (C) Copyright 1999 Red Hat Software
I2O Block Storage OSM v0.9
   (c) Copyright 1999-2001 Red Hat Software.
i2o_block: Checking for Boot device...
i2o_block: Checking for I2O Block devices...
I2O LAN OSM (C) 1999 University of Helsinki.
i2o_scsi.c: Version 0.0.1
  chain_pool: 0 bytes @ f7c46f40
  (512 byte buffers X 4 can_queue X 0 i2o controllers)

However, when the non-working kernels boot, this happens before the
loading Adaptec I2O Raid message (this message never appears).

kmod: failed to exec /sbin/modprobe -s -k block-major-8 errno=3D2
VFS: Cannot open root device "sda2" or 08:02
Please append a correct "root=3D" boot option
kernel panic: VFS: Unable to mount root fs on 08:02

The following options are enabled:

Adaptec AACRAID support
Adaptec AIC79xx support
Adaptec I2O Raid support
I2O support
I2O PCI support
I2O Block support
I2O LAN support
I2O SCSI support
I2O /proc support

I have tried this with the support in the kernel and as modules.  The
same thing happens each time.  Is there something I have done wrong or
is this broken?
--=20
    Lawrence MacIntyre     865.574.8696     lpz@ornl.gov
               Oak Ridge National Laboratory
High Performance Information Infrastructure Technology Group


--=-AVzEnopktCjonALiiD2S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQA/w9XUCNjP8rawCW4RAvFyAJ9iB3B4a0qhuh6fZb54o+VSbxPSawCdENtQ
cUPILgr0EEY/NUneTiPX+WA=
=UMN9
-----END PGP SIGNATURE-----

--=-AVzEnopktCjonALiiD2S--
