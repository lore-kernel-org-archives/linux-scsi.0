From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/23] scsi_dh_alua: use unaligned access macros
Date: Thu, 03 Sep 2015 23:43:16 -0400
Message-ID: <yq1mvx27stn.fsf@sermon.lab.mkp.net>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	<1440679281-13234-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbbIDDnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2015 23:43:40 -0400
In-Reply-To: <1440679281-13234-10-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Thu, 27 Aug 2015 14:41:07 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Use 'get_unaligned_XX' and 'put_unaligned_XX' instead of
Hannes> open-coding it.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
