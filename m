From: Tom Oehser <tom@toms.net>
Subject: megaraid doesn't detect when bios jumper is off...
Date: Wed, 21 Jul 2004 22:36:04 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407212232110.548@jupiter.toms.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Jupiter.Toms.NET ([64.32.223.162]:52104 "EHLO jupiter.toms.net")
	by vger.kernel.org with ESMTP id S266678AbUGVCgG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2004 22:36:06 -0400
Received: from Jupiter.Toms.NET (Jupiter.Toms.NET [64.32.223.162])
	by jupiter.toms.net (8.12.10/8.12.10) with ESMTP id i6M2a4p1000958
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2004 22:36:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi, I have a MegaRAID SATA 150-6, which is in the same box as a
Mylex AcceleRaid-250 which is the boot drive.  The motherboard
doesn't give a way to control boot priority between scsi cards,
so I set the bios-disable jumper on the MegaRAID card, so that
it will boot the Mylex, which works fine...

BUT, the MegaRAID driver isn't detecting the MegaRAID when its
boot bios is disabled!  I can't find a way to get the driver to
find it and enable it...  And the BIOS setup of the MegaRAID is
not seeming to have a way to tell it not to try to boot...

So, if I enable the bios jumper on the MegaRAID, it tries to boot
from it (which fails miserably, as it isn't a boot drive), and if
I disable the bios jumper on the MegaRAID, it doesn't try to boot
it, but then the Linux driver doesn't enable it, either!

Help?

-Tom

