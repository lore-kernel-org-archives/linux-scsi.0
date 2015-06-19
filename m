From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 15/20] [SCSI] mpt3sas: Return host busy error status to SML when DMA mapping of scatter gather list fails for a SCSI command
Date: Fri, 19 Jun 2015 16:40:23 -0400
Message-ID: <yq1oakba0ug.fsf@sermon.lab.mkp.net>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-16-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20191 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbbFSUlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 16:41:53 -0400
In-Reply-To: <1434102153-38581-16-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 12 Jun 2015 15:12:27 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> scsi_dma_map API will return a negative value (i.e. -ENOMEM) if DMA
> mapping of sg lists fails and zero if the sg list in the SCSI cmd is
> NULL. But drivers doesn't handled sg list DMA mapping failure case
> properly.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
