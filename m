From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: remove the disable_blk_mq host flag
Date: Fri, 15 Jul 2016 15:11:55 -0400
Message-ID: <yq1lh12iumc.fsf@sermon.lab.mkp.net>
References: <1468383545-28503-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48418 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbcGOTMG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2016 15:12:06 -0400
In-Reply-To: <1468383545-28503-1-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Wed, 13 Jul 2016 13:19:05 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> We've had scsi-mq for 2.5 years now, so we can remove the
Christoph> unused flag to disable the code on a per-host basis that was
Christoph> put in for unexpected emergencies during bringup.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
