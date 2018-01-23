From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/5] scsi: Add VENDOR_SPECIFIC sense code definitions
Date: Mon, 22 Jan 2018 19:27:44 -0500
Message-ID: <yq1po61iflr.fsf@oracle.com>
References: <20180119151113.80768-1-hare@suse.de>
        <20180119151113.80768-3-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbeAWA2A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 19:28:00 -0500
In-Reply-To: <20180119151113.80768-3-hare@suse.de> (Hannes Reinecke's message
        of "Fri, 19 Jan 2018 16:11:10 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> Some older devices will return vendor specific sense codes, so
> we should be adding a definition for it.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
