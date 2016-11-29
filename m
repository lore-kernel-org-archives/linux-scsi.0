From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: bnx2i + bnx2fc: convert to generic workqueue (#2)
Date: Tue, 29 Nov 2016 11:56:57 -0500
Message-ID: <yq160n6ns12.fsf@sermon.lab.mkp.net>
References: <20161122174813.16184-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31555 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756435AbcK2Q5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:57:19 -0500
In-Reply-To: <20161122174813.16184-1-bigeasy@linutronix.de> (Sebastian Andrzej
        Siewior's message of "Tue, 22 Nov 2016 18:48:08 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

>>>>> "Sebastian" == Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

Sebastian> This is the a repost + fixups to get the patches applied
Sebastian> against v4.9-rc4.  mkp's scsi for-next tree can be merged
Sebastian> with no conflicts.

Chad?

-- 
Martin K. Petersen	Oracle Linux Engineering
