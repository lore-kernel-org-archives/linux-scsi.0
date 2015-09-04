From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/23] scsi_dh_alua: Use vpd_pg83 information
Date: Thu, 03 Sep 2015 23:37:57 -0400
Message-ID: <yq18u8m97my.fsf@sermon.lab.mkp.net>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	<1440679281-13234-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22552 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbbIDDiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2015 23:38:07 -0400
In-Reply-To: <1440679281-13234-3-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Thu, 27 Aug 2015 14:41:00 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> The SCSI device now has the VPD page 0x83 information attached,
Hannes> so there is no need to query it again.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
