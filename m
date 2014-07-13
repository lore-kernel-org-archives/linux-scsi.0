From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 04/10] sd: don't use scsi_setup_blk_pc_cmnd for flush requests
Date: Sun, 13 Jul 2014 10:07:50 -0400
Message-ID: <yq1d2d91he1.fsf@sermon.lab.mkp.net>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
	<1404048881-19526-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48844 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaGMOH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 10:07:56 -0400
In-Reply-To: <1404048881-19526-5-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 29 Jun 2014 15:34:35 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Simplify handling of flush requests by setting up the command
Christoph> directly instead of initializing request fields and then
Christoph> calling scsi_setup_blk_pc_cmnd to propagate the information
Christoph> into the command.

Looks good.

Christoph> Also rename scsi_setup_flush_cmnd to sd_setup_flush_cmnd for
Christoph> consistency.

Been wanting to do that for ages...

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
