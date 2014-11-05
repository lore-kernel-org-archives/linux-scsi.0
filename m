From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi: only re-lock door after EH on devices that were reset
Date: Tue, 04 Nov 2014 20:57:59 -0500
Message-ID: <yq1fvdyh0ig.fsf@sermon.lab.mkp.net>
References: <20141103183640.GA6718@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48117 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaKEB6O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 20:58:14 -0500
In-Reply-To: <20141103183640.GA6718@lst.de> (Christoph Hellwig's message of
	"Mon, 3 Nov 2014 19:36:40 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Meelis Roos <meelis.roos@ut.ee>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Setups that use the blk-mq I/O path can lock up if a host
Christoph> with a single device that has its door locked enters EH.
Christoph> Make sure to only send the command to re-lock the door to
Christoph> devices that actually were reset and thus might have lost
Christoph> their state.  Otherwise the EH code might be get blocked on
Christoph> blk_get_request as all requests for non-reset devices might
Christoph> be in use.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
