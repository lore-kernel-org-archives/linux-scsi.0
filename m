From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 6/6] scsi_debug: allow huge transfer length for read/write commands
Date: Mon, 02 Jun 2014 13:08:08 -0400
Message-ID: <yq138fn9r47.fsf@sermon.lab.mkp.net>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
	<1401717409-5236-7-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44120 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaFBRI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 13:08:27 -0400
In-Reply-To: <1401717409-5236-7-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 2 Jun 2014 22:56:49 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> Also, this increases sg_tablesize and max_segment_size,
Akinobu> otherwise the maximum transfer length is limited to 64MB.
Akinobu> (sg_tablesize * max_segment_size = 256 * 256KB)

Things are easy for scsi_debug. And since we're not changing defaults
for any of the HBA ASICs I'm OK with it.

But I would like us to be very cautious about going above 0xffff blocks
in general. I have seen several devices that misbehave if you do. Or
garble any blocks beyond 0xffff.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
