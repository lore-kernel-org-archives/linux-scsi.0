From: "Alexandru N. Barloiu" <slak@light.kappa.ro>
Subject: Unknown problem with Adaptec Raid 2400A card
Date: 26 Jul 2003 02:59:24 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059177564.7003.214.camel@hammer.dale.ro>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from light.kappa.ro ([194.102.254.118]:54947 "EHLO mx.dale.ro")
	by vger.kernel.org with ESMTP id S272389AbTGYXoW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2003 19:44:22 -0400
Received: from astro.dale.ro (localhost [127.0.0.1])
	by mx.dale.ro (Postfix) with SMTP id 48B8E40518B1
	for <linux-scsi@vger.kernel.org>; Sat, 26 Jul 2003 03:04:02 +0300 (EEST)
Received: from hammer.dale.ro (hammer.dale.ro [193.231.198.250])
	by mx.dale.ro (Postfix) with ESMTP id 680C740518B1
	for <linux-scsi@vger.kernel.org>; Sat, 26 Jul 2003 03:03:56 +0300 (EEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
I have a Adaptec Raid 2400A card working in a pentium4 system, standard
Intel MB (i850), working with 4 WDC WD1000JB-32CWE0 drives, and kernel
2.4.20-xfs. I am using the dpt-i2o compiled in the kernel image.
It's been working without any kind of problems for three months now,
until a week ago. Every 2-3 hours it shuts down for no good reason at
all. The system it's very well cooled ( ~30Celsius degrees ), clean ( no
dust or anything ). I don't know what to make of this, because every bit
of hw in that system is branded, well tested, well used; it isn't even
used all that much.

Here is the dump from kern.log about the disconect:
Jul 25 02:09:23 orphan kernel: dpti0: SCSI Timeout-Device (0,0,0) hba
status=0xa, dev status=0x0, cmd=0x28
Jul 25 02:09:52 orphan last message repeated 3 times
Jul 25 02:10:32 orphan kernel: dpti0: Trying to reset device
Jul 25 02:10:32 orphan kernel: dpti0: Device reset not supported
Jul 25 02:10:32 orphan kernel: dpti0: Bus reset: SCSI Bus 0: tid: 11
Jul 25 02:10:32 orphan kernel: dpti0: Bus reset success.
Jul 25 02:10:47 orphan kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 0 channel 0 id 0 lun 0
Jul 25 02:11:17 orphan last message repeated 3 times

I've tryed to search on google allready for any other reports, but found
none. I know that nobody is a visionary here and also that I don't give
a lot of details. If u could just point me in the right direction in
solveing this issue i would greatly appreciate.

-- 
Alexandru N. Barloiu <slak@light.kappa.ro>
Dale Media

