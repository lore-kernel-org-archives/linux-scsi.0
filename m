From: Nicolas Raspail <nicolas@whisperingvault.net>
Subject: aic7xxx, linux 2.6.14 = No or incomplete CDB
Date: Mon, 28 Nov 2005 09:43:15 +0100
Message-ID: <20051128094315.miavexpc004s0ggw@www.whisperingvault.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dodger.whisperingvault.net ([82.66.64.70]:29390 "EHLO
	mail.whisperingvault.net") by vger.kernel.org with ESMTP
	id S1751252AbVK1InX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 03:43:23 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.whisperingvault.net (Postfix) with ESMTP id D45231C062AF
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 09:43:15 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Just after my switch from 2.6.13 to 2.6.14, I have some problems with 
my scsi devices when using k3b (software to burn cdrom) and vmware.

I have filled a bug in Debian against k3b 
(http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=339871) but as I'm 
not 100% sure it's a k3b bug, I'm CCing you. Maybe you will have some 
clues about this problem.

To summarize, when I launch k3b, it blocks on scanning devices and in 
/var/log/kern.log, I got a lot of scsi errors :

Nov 19 12:09:23 deus kernel: (scsi0:A:4:0): No or incomplete CDB sent to
device.
Nov 19 12:09:23 deus kernel: scsi0: Issued Channel A Bus Reset. 1 SCBs
aborted
Nov 19 12:09:23 deus kernel: (scsi0:A:4:0): No or incomplete CDB sent to
device.
Nov 19 12:09:23 deus kernel: scsi0: Issued Channel A Bus Reset. 1 SCBs
aborted
Nov 19 12:09:24 deus kernel: (scsi0:A:4:0): No or incomplete CDB sent to
device.
Nov 19 12:09:24 deus kernel: scsi0: Issued Channel A Bus Reset. 1 SCBs
aborted
Nov 19 12:09:24 deus kernel: sr 0:0:4:0: SCSI error: return code =
0x70000

Yesterday, I launch vmware, and the same problem arise. With a 2.6.13 
kernel and aic7xxx drivers version 6.x, everything is ok.

Thanks

Nicolas

PS : please, CC me as I have not suscribed to this list. Thanks

