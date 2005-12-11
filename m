From: Pete Zaitcev <zaitcev@redhat.com>
Subject: put_disk in cciss
Date: Sun, 11 Dec 2005 15:57:53 -0800
Message-ID: <20051211155753.1d66b65b.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:24028 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750919AbVLKX7H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Dec 2005 18:59:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: coughlan@redhat.com, zaitcev@redhat.com, linux-scsi@vger.kernel.org

Hi, Mike:

Tom pointed me to this:
 http://marc.theaimsgroup.com/?l=linux-kernel&m=113233643423550&w=2

Which seems to be in effect, in today's git:
 http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;h=a9e33db46e68b5432627835ea1945f02d40d861c;hb=e4f5c82a92c2a546a16af1614114eec19120e40a;f=drivers/block/cciss.c

I suspect that those put_disk calls have to be dropped, because they
are done in free_hba(). Right?

-- Pete
