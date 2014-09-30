From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: add a CONFIG_SCSI_MQ_DEFAULT option
Date: Tue, 30 Sep 2014 17:57:09 -0400
Message-ID: <yq1egusn556.fsf@sermon.lab.mkp.net>
References: <1412090453-24484-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17808 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaI3V5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 17:57:16 -0400
In-Reply-To: <1412090453-24484-1-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Tue, 30 Sep 2014 17:20:53 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Add a Kconfig option to enable the blk-mq path for SCSI by
Christoph> default to ease testing and deployment in setups that know
Christoph> they benefit from blk-mq.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
