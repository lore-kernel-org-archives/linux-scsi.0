From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Write same support v4
Date: Fri, 16 Mar 2012 14:43:12 -0400
Message-ID: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51585 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2CPSnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2012 14:43:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org


Changes since v3:

 - Document that the REQ_NOMERGE_FLAGS is used for both bio and request
   merging.

 - Do size accounting correctly so we don't have to use
   blk_add_request_payload(). This also fixes an issue discovered by
   Mike: When running over a flaky iSCSI connection we would end up
   completing one block and subsequently fail trying to redrive the
   remainder of the I/O. An unfortunate side effect of the discrepancy
   between the DMA transfer size and the logical block range affected by
   the command.

I put a writesame4 branch on:

   git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git

-- 
Martin K. Petersen	Oracle Linux Engineering

