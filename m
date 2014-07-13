From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/10] scsi: restructure command initialization for TYPE_FS requests
Date: Sun, 13 Jul 2014 10:04:42 -0400
Message-ID: <yq1lhrx1hj9.fsf@sermon.lab.mkp.net>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
	<1404048881-19526-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41524 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaGMOEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 10:04:48 -0400
In-Reply-To: <1404048881-19526-3-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 29 Jun 2014 15:34:33 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> We should call the device handler prep_fn for all TYPE_FS
Christoph> requests, not just simple read/write calls that are handled
Christoph> by the disk driver.

Christoph> Restructure the common I/O code to call the prep_fn handler
Christoph> and zero out the CDB, and just leave the call to scsi_init_io
Christoph> to the ULDs.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
