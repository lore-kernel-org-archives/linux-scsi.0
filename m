From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Discard merging / Write same support v5
Date: Tue, 18 Sep 2012 12:19:24 -0400
Message-ID: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27635 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2IRQTt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2012 12:19:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk, shli@kernel.org, snitzer@redhat.com

I've been beating on this patch kit for the last few weeks with a bunch
of different devices. I have also tested extensively with Shaohua Li's
MD RAID0 discard support.

The only functional change is support for discard and write same
bio/request merging. Other than that there were a few tweaks for later
kernels by both Mike and me.

I put a writesame5 branch on:

   git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git

It's against block/for-3.7/core.

[PATCH 1/8] block: Clean up special command handling logic
[PATCH 2/8] block: Consolidate command flag and queue limit checks
[PATCH 3/8] block: Implement support for WRITE SAME
[PATCH 4/8] block: Make blkdev_issue_zeroout use WRITE SAME
[PATCH 5/8] block: ioctl to zero block ranges
[PATCH 6/8] scsi: Add a report opcode helper
[PATCH 7/8] sd: Permit merged discard requests
[PATCH 8/8] sd: Implement support for WRITE SAME

-- 
Martin K. Petersen	Oracle Linux Engineering
