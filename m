From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/20] [SCSI] mpt3sas: Don't block the drive when drive addition under the control of SML
Date: Fri, 19 Jun 2015 11:05:48 -0400
Message-ID: <yq1mvzvd9gz.fsf@sermon.lab.mkp.net>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-4-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42640 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbFSPGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 11:06:19 -0400
In-Reply-To: <1434102153-38581-4-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 12 Jun 2015 15:12:15 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org


> During hot-plugging of a disk(having a flaky link), the disk addition
> stops and any further disk addition or removal doesn't happen on that
> controller.

> This is because, when driver receives DELAY_NOT_RESPONDING event for
> a disk while it is undergoing addition at the SCSI Transport layer,
> the driver would block the I/O to that disk resulting in a
> deadlock. i.e the disk addition work couldn't be completed at the
> SCSI Transport Layer as it can't send any I/Os (such as Inquiry,
> Report LUNs etc) to the disk as I/Os are blocked to this drive. Also
> any subsequent device removal (TARGET_NOT_RESPONDING) or link
> update(RC_PHY_CHANGED) event couldn't be processed as they are in the
> queue to get processed after disk addition event.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
