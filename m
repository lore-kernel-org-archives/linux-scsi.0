From: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Subject: (unknown)
Date: Mon, 4 Oct 2004 10:08:34 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4939.1096877314@www43.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:61058 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267549AbUJDIIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2004 04:08:36 -0400
Subject: 
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org

Kai wrote:
> Whenever you report tape problems, it would be helpful to know at least 
> the drive mode (fixed vs. variable block mode) and block size (if fixed 
> block mode). You can get this information with 'mt status'.

With kernel 2.6.7 its working and i do get this:

[...without a tape...]
$ mt status
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (50000):
 DR_OPEN IM_REP_EN
$ mt asf 0
/dev/tape: Input/output error
$ mt setblk 512
/dev/tape: No medium found

[...with a DDS-3 tape...]
$ mt asf 0
$ mt status
SCSI 2 tape drive:
File number=0, block number=0, partition=0.
Tape block size 0 bytes. Density code 0x25 (DDS-3).
Soft error count since last status=0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN
$ tar -tvf /dev/tape
[...file listing...]

sorry, the machine in question is currently blocked.
at the moment i cant supply results from 2.6.9-rc3 kernel build.
But it were the very same command sequence, so it should work
in theory, but in pratice i got access errors on command line.

> The sym53c8xx_2 driver has had problems in speed negotiation 
> recently. As I mentioned, the speed negotiation did not succeed with my 
> drives at some point. I have here patch-2.6.9-rc2-bk14 and it does not 
> seem to have those fixes yet. It might be good if you could try a new 
> kernel (2.6.9-rc3 is certainly new enough) and see if this helps.

I think i have tried those version and it failed, but i will retest
with latest BitKeeper version probably tonight and report on that.

-Alex.

-- 
GMX ProMail mit bestem Virenschutz http://www.gmx.net/de/go/mail
+++ Empfehlung der Redaktion +++ Internet Professionell 10/04 +++

