From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/23] scsi_dh_alua: Disable ALUA handling for non-disk devices
Date: Thu, 03 Sep 2015 23:36:52 -0400
Message-ID: <yq1d1xy97or.fsf@sermon.lab.mkp.net>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	<1440679281-13234-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22240 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbbIDDhD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2015 23:37:03 -0400
In-Reply-To: <1440679281-13234-2-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Thu, 27 Aug 2015 14:40:59 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Non-disk devices might support ALUA, but the firmware
Hannes> implementation is untested and frequently broken.  As we're
Hannes> don't actually need it disable ALUA support for non-disk device
Hannes> for now.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
