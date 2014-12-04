From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/4] scsi: never drop to untagged mode during queue ramp down
Date: Wed, 03 Dec 2014 21:28:16 -0500
Message-ID: <yq1tx1cjghr.fsf@sermon.lab.mkp.net>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
	<1416839781-26988-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44075 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaLDC2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 21:28:23 -0500
In-Reply-To: <1416839781-26988-3-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Mon, 24 Nov 2014 15:36:19 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Dropping to untagged mode when ramping down a queue due to
Christoph> QUEUE FULL events has two problems:

Christoph>  - nothing in the midlayer or drivers ever moves back to
Christoph> tagged mode during queue ramp up.  - cmd_per_lun isn't the
Christoph> untagged queue depth for many modern drivers that can handle
Christoph> multiple untagged commands, and this is the only place in the
Christoph> midlayer assuming that.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
