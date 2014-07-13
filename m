From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05/10] sd: don't use scsi_setup_blk_pc_cmnd for write same requests
Date: Sun, 13 Jul 2014 10:14:15 -0400
Message-ID: <yq18unx1h3c.fsf@sermon.lab.mkp.net>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
	<1404048881-19526-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42546 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaGMOO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 10:14:26 -0400
In-Reply-To: <1404048881-19526-6-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 29 Jun 2014 15:34:36 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Simplify handling of write same requests by setting up the
Christoph> command directly instead of initializing request fields and
Christoph> then calling scsi_setup_blk_pc_cmnd to propagate the
Christoph> information into the command.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
