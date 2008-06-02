From: "Florian Meister" <Florian.Meister@teleport.vol.at>
Subject: st2: Error 20000 (sugg. bt 0x0, driver bt 0x0, host bt 0x2).
Date: Mon, 2 Jun 2008 12:36:54 +0200
Message-ID: <37D771CE6147AC42AF474A9B2AF003EC125E1C@mhex006.medienhaus.at>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mhmxoutu01.tele.net ([194.183.153.44]:37360 "EHLO
	mhmxoutu01.tele.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYFBKz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 06:55:59 -0400
Received: from mhex006.medienhaus.at ([194.208.19.46])
	by mhmxoutu01.tele.net (8.14.1/8.14.1/Debian-4) with ESMTP id m52Aamlv006048
	for <linux-scsi@vger.kernel.org>; Mon, 2 Jun 2008 12:36:49 +0200
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a Overland NEO2000 tape library with 2 HP Storageworks Ultrium-3
drives installed.

The Problem is that the drive(s) regularly get "unreachable". I have two
other libraries of the same type with LTO-1 and LTO-2 drives, which are
working perfect.

First I thought it's a hardware problem, so I changed everything - The
HBA's, the Library, the tapes, the Fibre-channel conversion card, all
cables, even the server. I even switched from debian etch to a supported
operating system (RedHat AS4). No luck at all.

Can somebody check the output of the log below and tell me what is
happening there exactly ? I did a lot of research but could not find
anything regarding this issue.

Many thanks, Florian


May 26 21:35:37 mhbackupu01 kernel: st2: Error 20000 (sugg. bt 0x0,
driver bt 0x0, host bt 0x2).
May 26 21:37:22 mhbackupu01 kernel: qla2xxx 0000:09:04.1: scsi(1:0:0:1):
ABORTing cmd=f2c54800 sp=f2e46200 flags=1802 state=2 ext_hist=63647074
jiffies = 0xbc0214, timeout=1, dpc_flags=4080000,
vis_ha->dpc_flags=4080000 q->flag=0 ha=f7adc258 vis_ha=f7adc258
sp->ha=f7adc258
May 26 21:37:22 mhbackupu01 kernel: qla2xxx_eh_abort(1): aborting sp
f2e46200 from RISC. pid=17202100 sp->state=2 q->q_flag=0
May 26 21:37:33 mhbackupu01 kernel: qla2xxx 0000:09:04.1: scsi(1:0:0:1):
ABORTing cmd=f2c54800 sp=f2e46200 flags=1802 state=2 ext_hist=63647074
jiffies = 0xbc2d0c, timeout=1, dpc_flags=4080000,
vis_ha->dpc_flags=4080000 q->flag=0 ha=f7adc258 vis_ha=f7adc258
sp->ha=f7adc258
May 26 21:37:33 mhbackupu01 kernel: qla2xxx_eh_abort(1): aborting sp
f2e46200 from RISC. pid=17202100 sp->state=2 q->q_flag=0
May 26 21:37:34 mhbackupu01 kernel: qla2xxx 0000:09:04.1: scsi(1:0:0:1):
DEVICE_RESET cmd=f2c54800 jiffies = 0xbc30f4, timeout=1,
dpc_flags=4080000, status=80000 allowed=0 ha=f7adc258 vis_ha=f7adc258.
May 26 21:37:34 mhbackupu01 kernel: qla2xxx 0000:09:04.1: scsi(1:0:0:1):
DEVICE RESET SUCCEEDED.
May 26 21:37:49 mhbackupu01 kernel: qla2xxx 0000:09:04.1: scsi(1:0:0:1):
ABORTing cmd=f2c54800 sp=f2e46200 flags=1802 state=2 ext_hist=63647074
jiffies = 0xbc6b89, timeout=1, dpc_flags=4080000,
vis_ha->dpc_flags=4080000 q->flag=0 ha=f7adc258 vis_ha=f7adc258
sp->ha=f7adc258
May 26 21:37:49 mhbackupu01 kernel: qla2xxx_eh_abort(1): aborting sp
f2e46200 from RISC. pid=17202100 sp->state=2 q->q_flag=0
May 26 21:37:49 mhbackupu01 kernel: qla2xxx 0000:09:04.1: scsi(1:0:0:1):
LOOP RESET ISSUED.
May 26 21:37:49 mhbackupu01 kernel: qla2xxx 0000:09:04.1: LOOP DOWN
detected (2 e678 0).
May 26 21:37:49 mhbackupu01 kernel: qla2xxx 0000:09:04.1: LOOP UP
detected (2 Gbps).
May 26 21:38:19 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Mailbox
command timeout occured. Issuing ISP abort.
May 26 21:38:19 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Performing ISP
error recovery - ha= f7adc258.
May 26 21:38:20 mhbackupu01 kernel: qla2xxx 0000:09:04.1: LOOP UP
detected (2 Gbps).
May 26 21:43:19 mhbackupu01 kernel: qla2xxx 0000:09:04.1:
qla2xxx_eh_bus_reset: reset succeded
May 26 21:43:20 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Mailbox
command timeout occured. Issuing ISP abort.
May 26 21:43:20 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Performing ISP
error recovery - ha= f7adc258.
May 26 21:43:25 mhbackupu01 kernel: qla2xxx 0000:09:04.1: LOOP UP
detected (2 Gbps).
May 26 21:43:29 mhbackupu01 kernel: qla2xxx 0000:09:04.1: scsi(1:0:0:1):
ADAPTER RESET issued.
May 26 21:48:25 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Mailbox
command timeout occured. Issuing ISP abort.
May 26 21:48:25 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Performing ISP
error recovery - ha= f7adc258.
May 26 21:48:25 mhbackupu01 kernel: qla2xxx 0000:09:04.1: LOOP UP
detected (2 Gbps).
May 26 21:52:56 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Performing ISP
error recovery - ha= f7adc258.
May 26 21:52:57 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Mailbox
command timeout occured. Issuing ISP abort.
May 26 21:53:27 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Mailbox
command timeout occured. Issuing ISP abort.
May 26 21:53:27 mhbackupu01 kernel: qla2xxx 0000:09:04.1: [ERROR] Failed
to load segment 0 of firmware
May 26 21:53:27 mhbackupu01 kernel: Mailbox registers:
May 26 21:53:27 mhbackupu01 kernel: scsi(1): mbox 0 0x4001
May 26 21:53:27 mhbackupu01 kernel: scsi(1): mbox 1 0xaaaa
May 26 21:53:27 mhbackupu01 kernel: scsi(1): mbox 2 0x5555
May 26 21:53:27 mhbackupu01 kernel: scsi(1): mbox 3 0xaa55
May 26 21:53:27 mhbackupu01 kernel: scsi(1): mbox 4 0x55aa
May 26 21:53:27 mhbackupu01 kernel: scsi(1): mbox 5 0xa5a5
May 26 21:53:57 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Mailbox
command timeout occured. Issuing ISP abort.
May 26 21:54:57 mhbackupu01 last message repeated 2 times
May 26 21:55:27 mhbackupu01 kernel: qla2xxx 0000:09:04.1: Mailbox
command timeout occured. Issuing ISP abort.
May 26 21:55:27 mhbackupu01 kernel: qla2xxx 0000:09:04.1:
qla2xxx_eh_host_reset: reset succeded
May 26 21:55:37 mhbackupu01 kernel: scsi: Device offlined - not ready
after error recovery: host 1 channel 0 id 0 lun 1
May 26 21:55:37 mhbackupu01 kernel: st3: Error 10000 (sugg. bt 0x0,
driver bt 0x0, host bt 0x1).
May 26 21:55:37 mhbackupu01 kernel: scsi1 (0:1): rejecting I/O to
offline device
