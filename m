From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/10] scsi: move the nr_phys_segments assert into scsi_init_io
Date: Sun, 13 Jul 2014 10:03:03 -0400
Message-ID: <yq1pph91hm0.fsf@sermon.lab.mkp.net>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
	<1404048881-19526-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaGMODO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 10:03:14 -0400
In-Reply-To: <1404048881-19526-2-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 29 Jun 2014 15:34:32 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> scsi_init_io should only be called for requests that transfer
Christoph> data, so move the assert that a request has segments from the
Christoph> callers into scsi_init_io.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
