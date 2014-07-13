From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/10] sd: retry write same commands
Date: Sun, 13 Jul 2014 10:36:28 -0400
Message-ID: <yq1zjgdz5oz.fsf@sermon.lab.mkp.net>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
	<1404048881-19526-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16420 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaGMOge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 10:36:34 -0400
In-Reply-To: <1404048881-19526-8-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 29 Jun 2014 15:34:38 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Currently cmd->allowed is initialized from rq->retries for
Christoph> write same commands, but retries is always 0 for non-BLOCK_PC
Christoph> requests.  Set it to the standard number of retries instead.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
