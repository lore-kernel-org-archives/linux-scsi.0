From: Krzysztof "Sierota (o2.pl/tlen.pl)" <Krzysztof.Sierota@firma.o2.pl>
Subject: 21610 & 2810 linux problems
Date: 29 Jun 2004 21:21:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088536919.2221.146.camel@rakieeta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepard.lm.pl ([212.244.46.42]:57233 "EHLO gepard.lm.pl")
	by vger.kernel.org with ESMTP id S265978AbUF2TYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2004 15:24:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Salyzyn <Mark_Salyzyn@adaptec.com>

Hi,

we are deploying several machines with 2810 and 21610 SATA RAID
controllers installed. However I see problems I am not able to solve so
far with the machine where both 21610 and 2810 controllers are
installed.

on RedHats 2.4.21-15.0.2.EL kernel I get:

Red Hat/Adaptec aacraid driver (1.1.2 Jun 29 2004 06:00:44)
AAC0: kernel 4.1.4 build 7211
AAC0: monitor 4.1.4 build 7211
AAC0: bios 4.1.0 build 7244
AAC0: serial bb1063fafaf001
AAC1: adapter kernel panic'd.
aacraid: device initialization failed.
scsi0 : aacraid
blk: queue c62f5418, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue c62f5218, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue c61afe18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue c61afc18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue c61afa18, I/O limit 4095Mb (mask 0xffffffff)

the 21610 controller fails

kernel 2.6.7:

Red Hat/Adaptec aacraid driver (1.1.2-lk1 Jun 29 2004)
AAC0: kernel 4.1.4 build 7244
AAC0: monitor 4.1.4 build 7244
AAC0: bios 4.1.0 build 7244
AAC0: serial bb6cebfafaf001
scsi0 : aacraid
  Vendor: ADAPTEC   Model: AAR-21610SA Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-21610SA Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-21610SA Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-21610SA Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-21610SA Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-21610SA Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-21610SA Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-21610SA Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
AAC1: kernel 4.1.4 build 7211
AAC1: monitor 4.1.4 build 7211
AAC1: bios 4.1.0 build 7244
AAC1: serial bb1063fafaf001
scsi1 : aacraid
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
ipr: IBM Power RAID SCSI Device Driver version: 2.0.7 (May 21, 2004)

I get both controllers, however, when I start adaptecs-smbe daemons the
system load is 2.0, there's lots of context switches, about 1k/s, and
iomagrd gets stuck in D state.

kernel 2.6.7-mm4:

Red Hat/Adaptec aacraid driver (1.1.2-lk2 Jun 29 2004)
ACPI: PCI interrupt 0000:03:01.0[A] -> GSI 48 (level, low) -> IRQ 48
AAC0: adapter kernel panic.
ACPI: PCI interrupt 0000:04:01.0[A] -> GSI 24 (level, low) -> IRQ 24
AAC0: kernel 4.1.4 build 7211
AAC0: monitor 4.1.4 build 7211
AAC0: bios 4.1.0 build 7244
AAC0: serial bb1063fafaf001
scsi1 : aacraid
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ADAPTEC   Model: AAR-2810SA Mirro  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 488279040 512-byte hdwr sectors (249999 MB)

yet again only one controller. System load about 2.0, anotyfid daemon,
looping:

sched_yield()                           = 0
ioctl(5, FIONREAD, [0])                 = 0
time(NULL)                              = 1088470036
sched_yield()                           = 0
ioctl(5, FIONREAD, [0])                 = 0
time(NULL)                              = 1088470036
sched_yield()                           = 0
ioctl(5, FIONREAD, [0])                 = 0
time(NULL)                              = 1088470036
sched_yield()                           = 0
ioctl(5, FIONREAD, [0])                 = 0
time(NULL)                              = 1088470036
sched_yield()                           = 0
ioctl(5, FIONREAD, [0])                 = 0

iomagrd, seems to be doing sth strange, too.


The system is CentOS-3.1 that is based on RedHats ES 3.0 SRPMS with all
updates. Could someone give any advice on the subject ? I can provide
more info.



