From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 4/6] sd: use READ_16 or WRITE_16 when transfer length is greater than 0xffff
Date: Mon, 02 Jun 2014 13:00:13 -0400
Message-ID: <yq1bnub9rhe.fsf@sermon.lab.mkp.net>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
	<1401717409-5236-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30486 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaFBRAb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 13:00:31 -0400
In-Reply-To: <1401717409-5236-5-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 2 Jun 2014 22:56:47 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "Elliott, Robert" <Elliott@hp.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> This change makes the scsi disk driver handle the requests
Akinobu> whose transfer length is greater than 0xffff with READ_16 or
Akinobu> WRITE_16.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
