From: Mark Haverkamp <markh@osdl.org>
Subject: mptspi dv problems
Date: Wed, 27 Sep 2006 10:37:06 -0700
Message-ID: <1159378627.21628.37.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:41897 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030484AbWI0RhQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 13:37:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The recent dv changes to scsi_transport_spi.c have fixed the problems
that I had with my U160 drives being set to async/narrow but there are
still problems with my U320 drive causing indefinite dv on my system.


Fusion MPT base driver 3.04.01
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.01
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
scsi1 : ioc0: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=20
scsi 1:0:1:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:1: Beginning Domain Validation
 target1:0:1: Ending Domain Validation
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sdb: 35566480 512-byte hdwr sectors (18210 MB)
sdb: Write Protect is off
SCSI device sdb: drive cache: write back w/ FUA
SCSI device sdb: 35566480 512-byte hdwr sectors (18210 MB)
sdb: Write Protect is off
SCSI device sdb: drive cache: write back w/ FUA
 sdb: sdb1
sd 1:0:1:0: Attached scsi disk sdb
sd 1:0:1:0: Attached scsi generic sg1 type 0
scsi 1:0:2:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:2: Beginning Domain Validation
 target1:0:2: Ending Domain Validation
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sdc: 35566480 512-byte hdwr sectors (18210 MB)
sdc: Write Protect is off
SCSI device sdc: drive cache: write back w/ FUA
SCSI device sdc: 35566480 512-byte hdwr sectors (18210 MB)
sdc: Write Protect is off
SCSI device sdc: drive cache: write back w/ FUA
 sdc: unknown partition table
sd 1:0:2:0: Attached scsi disk sdc
sd 1:0:2:0: Attached scsi generic sg2 type 0
scsi 1:0:3:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:3: Beginning Domain Validation
 target1:0:3: Ending Domain Validation
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sdd: 35566480 512-byte hdwr sectors (18210 MB)
sdd: Write Protect is off
SCSI device sdd: drive cache: write back w/ FUA
SCSI device sdd: 35566480 512-byte hdwr sectors (18210 MB)
sdd: Write Protect is off
SCSI device sdd: drive cache: write back w/ FUA
 sdd: unknown partition table
sd 1:0:3:0: Attached scsi disk sdd
sd 1:0:3:0: Attached scsi generic sg3 type 0
scsi 1:0:5:0: Processor         HP       D5989C           1.06 PQ: 0 ANSI: 2
 target1:0:5: Beginning Domain Validation
 target1:0:5: Ending Domain Validation
 target1:0:5: asynchronous
scsi 1:0:5:0: Attached scsi generic sg4 type 3
scsi 1:0:8:0: Direct-Access     HP 18.2G MAP3367NC#HJ     HPC6 PQ: 0 ANSI: 3
 target1:0:8: Beginning Domain Validation
mptscsih: ioc0: attempting task abort! (sc=f734bc80)
        command: cdb[0]=0x12: 12 00 00 00 60 00
mptbase: Initiating ioc0 recovery
mptscsih: ioc0: task abort: SUCCESS (sc=f734bc80)
 target1:0:1: Beginning Domain Validation
 target1:0:8: Domain Validation detected failure, dropping back
 target1:0:8: Domain Validation skipping write tests
 target1:0:8: Ending Domain Validation
 target1:0:8: asynchronous
SCSI device sde: 35566480 512-byte hdwr sectors (18210 MB)
sde: Write Protect is off
SCSI device sde: drive cache: write through w/ FUA
SCSI device sde: 35566480 512-byte hdwr sectors (18210 MB)
sde: Write Protect is off
 target1:0:1: Ending Domain Validation
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sde: drive cache: write through w/ FUA
 sde:<6> target1:0:2: Beginning Domain Validation
sd 1:0:8:0: Attached scsi disk sde
sd 1:0:8:0: Attached scsi generic sg5 type 0
scsi 1:0:9:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:9: Beginning Domain Validation
 target1:0:2: Ending Domain Validation
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:3: Beginning Domain Validation
 target1:0:9: Ending Domain Validation
 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sdf: 35566480 512-byte hdwr sectors (18210 MB)
 target1:0:3: Ending Domain Validation
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
sdf: Write Protect is off
 target1:0:5: Beginning Domain Validation
SCSI device sdf: drive cache: write back w/ FUA
SCSI device sdf: 35566480 512-byte hdwr sectors (18210 MB)
 target1:0:5: Ending Domain Validation
sdf: Write Protect is off
 target1:0:5: asynchronous
 target1:0:8: Beginning Domain Validation
SCSI device sdf: drive cache: write back w/ FUA
 sdf: unknown partition table
sd 1:0:9:0: Attached scsi disk sdf
sd 1:0:9:0: Attached scsi generic sg6 type 0
scsi 1:0:10:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:10: Beginning Domain Validation
mptscsih: ioc0: attempting task abort! (sc=f7501960)
        command: cdb[0]=0x12: 12 00 00 00 60 00
mptbase: Initiating ioc0 recovery
mptscsih: ioc0: task abort: SUCCESS (sc=f7501960)
 target1:0:10: Domain Validation Initial Inquiry Failed
 target1:0:10: Ending Domain Validation
 target1:0:10: asynchronous
 target1:0:8: Domain Validation detected failure, dropping back
SCSI device sdg: 35566480 512-byte hdwr sectors (18210 MB)
 target1:0:8: Domain Validation skipping write tests
 target1:0:8: Ending Domain Validation
sdg: Write Protect is off
 target1:0:8: asynchronous
 target1:0:9: Beginning Domain Validation
SCSI device sdg: drive cache: write through w/ FUA
SCSI device sdg: 35566480 512-byte hdwr sectors (18210 MB)
sdg: Write Protect is off
SCSI device sdg: drive cache: write through w/ FUA
 sdg: unknown partition table
sd 1:0:10:0: Attached scsi disk sdg
sd 1:0:10:0: Attached scsi generic sg7 type 0
scsi 1:0:11:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:11: Beginning Domain Validation
 target1:0:9: Ending Domain Validation
 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:10: Beginning Domain Validation
 target1:0:11: Ending Domain Validation
 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:10: Ending Domain Validation
 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sdh: 35566480 512-byte hdwr sectors (18210 MB)
sdh: Write Protect is off
SCSI device sdh: drive cache: write back w/ FUA
SCSI device sdh: 35566480 512-byte hdwr sectors (18210 MB)
sdh: Write Protect is off
SCSI device sdh: drive cache: write back w/ FUA
 sdh:<6> target1:0:11: Beginning Domain Validation
 target1:0:11: Ending Domain Validation
 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:1: Beginning Domain Validation
sd 1:0:11:0: Attached scsi disk sdh
sd 1:0:11:0: Attached scsi generic sg8 type 0
scsi 1:0:12:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:12: Beginning Domain Validation
 target1:0:1: Ending Domain Validation
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:2: Beginning Domain Validation
 target1:0:12: Ending Domain Validation
 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sdi: 35566480 512-byte hdwr sectors (18210 MB)
 target1:0:2: Ending Domain Validation
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
sdi: Write Protect is off
 target1:0:3: Beginning Domain Validation
SCSI device sdi: drive cache: write back w/ FUA
SCSI device sdi: 35566480 512-byte hdwr sectors (18210 MB)
sdi: Write Protect is off
SCSI device sdi: drive cache: write back w/ FUA
 sdi: sdi1
sd 1:0:12:0: Attached scsi disk sdi
sd 1:0:12:0: Attached scsi generic sg9 type 0
scsi 1:0:13:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:13: Beginning Domain Validation
 target1:0:3: Ending Domain Validation
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:5: Beginning Domain Validation
 target1:0:5: Ending Domain Validation
 target1:0:5: asynchronous
 target1:0:8: Beginning Domain Validation
 target1:0:13: Ending Domain Validation
 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sdj: 35566480 512-byte hdwr sectors (18210 MB)
mptscsih: ioc0: attempting task abort! (sc=f734bc80)
        command: cdb[0]=0x12: 12 00 00 00 60 00
mptbase: Initiating ioc0 recovery
mptscsih: ioc0: task abort: SUCCESS (sc=f734bc80)
 target1:0:8: Domain Validation detected failure, dropping back
sdj: Write Protect is off
 target1:0:8: Domain Validation skipping write tests
 target1:0:8: Ending Domain Validation
 target1:0:8: asynchronous
SCSI device sdj: drive cache: write back w/ FUA
 target1:0:9: Beginning Domain Validation
SCSI device sdj: 35566480 512-byte hdwr sectors (18210 MB)
sdj: Write Protect is off
SCSI device sdj: drive cache: write back w/ FUA
 sdj: unknown partition table
sd 1:0:13:0: Attached scsi disk sdj
sd 1:0:13:0: Attached scsi generic sg10 type 0
scsi 1:0:14:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:9: Ending Domain Validation
 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:10: Beginning Domain Validation
 target1:0:10: Ending Domain Validation
 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:11: Beginning Domain Validation
 target1:0:11: Ending Domain Validation
 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:12: Beginning Domain Validation
 target1:0:12: Ending Domain Validation
 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:13: Beginning Domain Validation
 target1:0:13: Ending Domain Validation
 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:14: asynchronous
 target1:0:1: Beginning Domain Validation
 target1:0:14: Beginning Domain Validation
 target1:0:14: Ending Domain Validation
 target1:0:1: Ending Domain Validation
 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:2: Beginning Domain Validation
SCSI device sdk: 35566480 512-byte hdwr sectors (18210 MB)
 target1:0:2: Ending Domain Validation
sdk: Write Protect is off
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:3: Beginning Domain Validation
SCSI device sdk: drive cache: write back w/ FUA
SCSI device sdk: 35566480 512-byte hdwr sectors (18210 MB)
sdk: Write Protect is off
SCSI device sdk: drive cache: write back w/ FUA
 sdk: sdk1
sd 1:0:14:0: Attached scsi disk sdk
sd 1:0:14:0: Attached scsi generic sg11 type 0
scsi 1:0:15:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
 target1:0:15: Beginning Domain Validation
 target1:0:3: Ending Domain Validation
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:5: Beginning Domain Validation
 target1:0:5: Ending Domain Validation
 target1:0:5: asynchronous
 target1:0:8: Beginning Domain Validation
 target1:0:15: Ending Domain Validation
 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
SCSI device sdl: 35566480 512-byte hdwr sectors (18210 MB)
mptscsih: ioc0: attempting task abort! (sc=f734bc80)
        command: cdb[0]=0x12: 12 00 00 00 60 00
mptbase: Initiating ioc0 recovery
mptscsih: ioc0: task abort: SUCCESS (sc=f734bc80)
 target1:0:8: Domain Validation detected failure, dropping back
 target1:0:8: Domain Validation skipping write tests
 target1:0:8: Ending Domain Validation
sdl: Write Protect is off
 target1:0:8: asynchronous
 target1:0:9: Beginning Domain Validation
SCSI device sdl: drive cache: write through w/ FUA
SCSI device sdl: 35566480 512-byte hdwr sectors (18210 MB)
sdl: Write Protect is off
SCSI device sdl: drive cache: write through w/ FUA
 sdl: unknown partition table
sd 1:0:15:0: Attached scsi disk sdl
sd 1:0:15:0: Attached scsi generic sg12 type 0
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities={Initiator}
scsi2 : ioc1: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=21
 target1:0:9: Ending Domain Validation
 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:10: Beginning Domain Validation
 target1:0:10: Ending Domain Validation
 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:11: Beginning Domain Validation
 target1:0:11: Ending Domain Validation
 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:12: Beginning Domain Validation
 target1:0:12: Ending Domain Validation
 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:13: Beginning Domain Validation
 target1:0:13: Ending Domain Validation
 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:14: Beginning Domain Validation
 target1:0:14: Ending Domain Validation
 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:15: Beginning Domain Validation
 target1:0:15: Ending Domain Validation
 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:1: Beginning Domain Validation
 target1:0:1: Ending Domain Validation
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:2: Beginning Domain Validation
 target1:0:2: Ending Domain Validation
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:3: Beginning Domain Validation
 target1:0:3: Ending Domain Validation
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:5: Beginning Domain Validation
 target1:0:5: Ending Domain Validation
 target1:0:5: asynchronous
 target1:0:8: Beginning Domain Validation
mptscsih: ioc0: attempting task abort! (sc=f734bc80)
        command: cdb[0]=0x12: 12 00 00 00 60 00
mptbase: Initiating ioc0 recovery
mptscsih: ioc0: task abort: SUCCESS (sc=f734bc80)
 target1:0:8: Domain Validation detected failure, dropping back
 target1:0:8: Domain Validation skipping write tests
 target1:0:8: Ending Domain Validation
 target1:0:8: asynchronous
 target1:0:9: Beginning Domain Validation
 target1:0:9: Ending Domain Validation
 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:10: Beginning Domain Validation
 target1:0:10: Ending Domain Validation
 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:11: Beginning Domain Validation
 target1:0:11: Ending Domain Validation
 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:12: Beginning Domain Validation
 target1:0:12: Ending Domain Validation
 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:13: Beginning Domain Validation
 target1:0:13: Ending Domain Validation
 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:14: Beginning Domain Validation
 target1:0:14: Ending Domain Validation
 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:15: Beginning Domain Validation
 target1:0:15: Ending Domain Validation
 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:1: Beginning Domain Validation
 target1:0:1: Ending Domain Validation
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:2: Beginning Domain Validation
 target1:0:2: Ending Domain Validation
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:3: Beginning Domain Validation
 target1:0:3: Ending Domain Validation
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:5: Beginning Domain Validation
 target1:0:5: Ending Domain Validation
 target1:0:5: asynchronous
 target1:0:8: Beginning Domain Validation
mptscsih: ioc0: attempting task abort! (sc=f734bc80)
        command: cdb[0]=0x12: 12 00 00 00 60 00
mptbase: Initiating ioc0 recovery
mptscsih: ioc0: task abort: SUCCESS (sc=f734bc80)
 target1:0:8: Domain Validation detected failure, dropping back
 target1:0:8: Domain Validation skipping write tests
 target1:0:8: Ending Domain Validation
 target1:0:8: asynchronous
 target1:0:9: Beginning Domain Validation
 target1:0:9: Ending Domain Validation
 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:10: Beginning Domain Validation
 target1:0:10: Ending Domain Validation
 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:11: Beginning Domain Validation
 target1:0:11: Ending Domain Validation
 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:12: Beginning Domain Validation
 target1:0:12: Ending Domain Validation
 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:13: Beginning Domain Validation
 target1:0:13: Ending Domain Validation
 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:14: Beginning Domain Validation
 target1:0:14: Ending Domain Validation
 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:15: Beginning Domain Validation
 target1:0:15: Ending Domain Validation
 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:1: Beginning Domain Validation
 target1:0:1: Ending Domain Validation
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:2: Beginning Domain Validation
 target1:0:2: Ending Domain Validation
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:3: Beginning Domain Validation
 target1:0:3: Ending Domain Validation
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
 target1:0:5: Beginning Domain Validation
 target1:0:5: Ending Domain Validation
 target1:0:5: asynchronous
 target1:0:8: Beginning Domain Validation
mptscsih: ioc0: attempting task abort! (sc=f734bc80)
        command: cdb[0]=0x12: 12 00 00 00 60 00
mptbase: Initiating ioc0 recovery


This seems to repeat forever.

-- 
Mark Haverkamp <markh@osdl.org>

