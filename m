From: "HAYERE Patrick" <patrick.hayere@c-s.fr>
Subject: [Fwd: Returned mail: User unknown]
Date: 08 Nov 2002 11:50:45 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1036756247.1366.58.camel@pc2822.si.c-s.fr>
Reply-To: patrick.hayere@free.fr
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pegase0.si.c-s.fr
        by pegase1.cie-signaux.fr  with ESMTP id LAA14614
        for <linux-scsi@vger.kernel.org>; Fri, 8 Nov 2002 11:54:03 +0100 (MET)
Received: from pegase0.si.c-s.fr
  by pegase0.si.c-s.fr  with ESMTP id LAA06963
  for <linux-scsi@vger.kernel.org>; Fri, 8 Nov 2002 11:50:11 +0100 (MET)
Received: from hermes17.si.c-s.fr
  by pegase0.si.c-s.fr  with ESMTP id LAA06955
  for <linux-scsi@vger.kernel.org>; Fri, 8 Nov 2002 11:50:10 +0100 (MET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I sent a bug report to a module author, but the mail addresses no longer exist.
Please find my message below.
If I can help, let me know.

Best regards.

Patrick HAYERE

P.S: what about UDF-write support on SCSI cd writers under Linux ?

   ----- The following addresses had permanent fatal errors -----
<ronald.van.cuijlenborg@tip.nl>
<nutty@dds.nl>:


From: HAYERE Patrick <patrick.hayere@c-s.fr>
To: nutty@dds.nl, ronald.van.cuijlenborg@tip.nl
Subject: g_NCR5380 System time desynchronisation and modinfo
Date: 08 Nov 2002 10:48:20 +0000

Hello,

I recently installed my Mustek ScanExpress 12000 SP scanner with its
native dtc436p card on Mandrake 8.1 and 9.0, with kernels 2.4:
modprobe g_NCR5380 ncr_irq=255 ncr_addr=0x220 ncr_3181=1
and so on
It works, thank you for your work.
Nevertheless, I remarked a little problem:
Each time I scan , my system time is shifted 20 or 30 second in the
past (ntpdate corrections).
I suppose this is due to the fact that the card has no irq and that the
system is suspended while communicating with the card.
Would-it be possible to re-synchronise the system clock with the
hardware clock each time your module is called ? Could this be a module
option ? How pertinent are my questions ?

Another bug is simpler to solve:
$ /sbin/modinfo  g_NCR5380
filename:    /lib/modules/2.4.19/kernel/drivers/scsi/g_NCR5380.o
description: <none>
author:      <none>
license:     "GPL"
parm:        ncr_irq int
parm:        ncr_dma int
parm:        ncr_addr int
parm:        ncr_5380 int
parm:        ncr_53c400 int
parm:        ncr_53c400a int
parm:        dtc_3181e int

As I had difficulties to find the driver for my scanner interface, I
think it would be interesting to document this a little bit more, for
example by refering to Mustek or listing supported scanners somewhere.
http://www.mostang.com/sane has info.

Thank you again for allowing me to use my scnner under Linux.

Best regards.
Patrick HAYERE






