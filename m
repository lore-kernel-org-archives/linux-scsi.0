From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 11:54:05 -0500
Message-ID: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1716 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751376AbWD1QyO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 12:54:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi Andrew,

I'd like to see aic94xx added to -mm to get it wider exposure subject to
the following caveats:

1. Hotplug is still a bit of a mess
2. SATA attachment doesn't work

Could you send any bugs found back to linux-scsi (not the kernel
bugzilla)?

The tree is at

master.kernel.org:/pub/scm/linux/kernel/git/jejb/aic94xx-sas-2.6.git

It's pretty much a working tree (as in most of the patches don't have
proper commit logs), so I'm going to flatten it once we get agreement
that it should go forwards into scsi-misc.

Thanks,

James


