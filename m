From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [REEEEPOST] bnx2i + bnx2fc: convert to generic workqueue (#3)
Date: Mon, 08 May 2017 22:04:33 -0400
Message-ID: <yq1inlass3y.fsf@oracle.com>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
        <20170504174427.6hebbnqwfgems6dg@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19404 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdEICFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 22:05:09 -0400
In-Reply-To: <20170504174427.6hebbnqwfgems6dg@linutronix.de> (Sebastian
        Andrzej Siewior's message of "Thu, 4 May 2017 19:44:28 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, QLogic-Storage-Upstream@qlogic.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@cavium.com>


Sebastian,

> Martin, do you see any chance to get this merged? Chad replied to the
> list that he is going to test it on 2017-04-10, didn't respond to the
> ping 10 days later. The series stalled last time in the same way.

I am very reluctant to merge something when a driver has an active
maintainer and that person has not acked the change.

That said, Chad: You have been sitting on this for quite a while. Please
make it a priority. In exchange for veto rights you do have to provide
timely feedback on anything that touches your driver.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
