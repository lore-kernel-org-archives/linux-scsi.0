From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 5/6] scsi: increase upper limit for max_sectors
Date: Mon, 02 Jun 2014 13:01:12 -0400
Message-ID: <yq17g4z9rfr.fsf@sermon.lab.mkp.net>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
	<1401717409-5236-6-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30967 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaFBRBZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 13:01:25 -0400
In-Reply-To: <1401717409-5236-6-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 2 Jun 2014 22:56:48 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> This commit increases the SCSI mid level's limitation for
Akinobu> max_sectors upto the block layer's limitation for
Akinobu> max_hw_sectors by extending the data type of max_sectors in
Akinobu> struct Scsi_Host and scsi_host_template, so that SCSI lower
Akinobu> level drivers can specify more than 0xffff.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
