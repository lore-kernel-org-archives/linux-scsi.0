From: Mogens Valentin <monz@danbbs.dk>
Subject: Locked Plextor PX-W1210S burner
Date: Thu, 18 Dec 2003 12:50:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FE19489.9940AEF2@danbbs.dk>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepc.post.tele.dk ([195.41.46.237]:7307 "EHLO
	pfepc.post.tele.dk") by vger.kernel.org with ESMTP id S265115AbTLRLrt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2003 06:47:49 -0500
Received: from danbbs.dk (0xc2ef15a4.bynxx4.adsl-dhcp.tele.dk [194.239.21.164])
	by pfepc.post.tele.dk (Postfix) with ESMTP id 6651226293C
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2003 12:47:42 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi <linux-scsi@vger.kernel.org>

For the first time, my Plextor PX-W1210S scsi burner has locked.

I can't get the media out.
Using scu, I've tried reset, allow removal and release, no go.

Typical response is something like:

scu: Sense Key = 0x5 = ILLEGAL REQUEST - Illegal request or CDB
parameter,
     Sense Code/Qualifier = (0x2c, 0) = Command sequence error


RH 7.3/2.4.21, all updates, Plextor Firmware Revision Level: 1.00 .

Any non-reboot ideas?


Plz answer directly, I'm not currently on this list; my apologies

-- 
Kind regards / venlig hilsen,
Mogens Valentin
