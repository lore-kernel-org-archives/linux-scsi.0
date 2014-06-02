From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/6] block: fix BLKSECTGET ioctl when max_sectors is greater than USHRT_MAX
Date: Mon, 02 Jun 2014 13:09:54 -0400
Message-ID: <yq1y4xf8cgt.fsf@sermon.lab.mkp.net>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
	<1401717409-5236-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44956 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaFBRKD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 13:10:03 -0400
In-Reply-To: <1401717409-5236-2-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 2 Jun 2014 22:56:44 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> BLKSECTGET ioctl loads the request queue's max_sectors as
Akinobu> unsigned short value to the argument pointer.  So if the
Akinobu> max_sector is greater than USHRT_MAX, the upper 16 bits of that
Akinobu> is just discarded.

Akinobu> In such case, USHRT_MAX is more preferable than the lower 16
Akinobu> bits of max_sectors.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
