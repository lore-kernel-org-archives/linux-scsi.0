From: Dave Hansen <haveblue@us.ibm.com>
Subject: 2.6.9-rc3-mm3 fails to detect aic7xxx
Date: Thu, 07 Oct 2004 12:40:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097178019.24355.39.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:9451 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267961AbUJGTka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 15:40:30 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

I just booted 2.6.9-rc3-mm3 and got the good ol' 

VFS: Cannot open root device "sda2" or unknown-block(0,0)
Please append a correct "root=" boot option
Kernel panic - not syncing: VFS: Unable to mount root fs on
unknown-block(0,0)

backing out bk-scsi.patch seems to fix it.  I believe this worked in
2.6.9-rc3-mm2.

-- Dave

