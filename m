From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fcoe: Fixup missing initialisation in fcoe_dcb_create()
Date: Tue, 18 Oct 2016 21:03:08 -0400
Message-ID: <yq1h989f8vn.fsf@sermon.lab.mkp.net>
References: <1476772756-121774-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26814 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754271AbcJSBDa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 21:03:30 -0400
In-Reply-To: <1476772756-121774-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 18 Oct 2016 08:39:16 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Found by 0-day robot.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
