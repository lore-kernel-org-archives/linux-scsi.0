From: Mogens Valentin <monz@danbbs.dk>
Subject: Ultra160 controller on 32bit pci
Date: Thu, 06 May 2004 10:15:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4099F408.E424C26A@danbbs.dk>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:41563 "EHLO
	pfepa.post.tele.dk") by vger.kernel.org with ESMTP id S261611AbUEFIMu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2004 04:12:50 -0400
Received: from danbbs.dk (0xc2ef15a4.bynxx4.adsl-dhcp.tele.dk [194.239.21.164])
	by pfepa.post.tele.dk (Postfix) with ESMTP id 73C6647FE13
	for <linux-scsi@vger.kernel.org>; Thu,  6 May 2004 10:12:49 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi <linux-scsi@vger.kernel.org>

Currently using Adaptec 29160, works fine, but it's only 160/2, after
all.
I'm curious if other controllers can provide better performance when
used on a 32bit pci bus?

In a few month I might switch to a pci-express/opteron setup, so I'd
like some indication about controllers for that bus.

I'm using two u320 10K disks + one fast10 device on a development
server/workstation, so I don't need an interprise-level ctrl.; but both
the pci32 and pci-express thingy should preferebly provide a narrow
connector as well.


I'm not currently on the scsi list, so if anyone would care to shed some
lights, please address me directly.
Thanks.

-- 
Kind regards,
Mogens Valentin
Networking, Security
www.danbbs.dk/~monz
Phone +45 32 525 878
