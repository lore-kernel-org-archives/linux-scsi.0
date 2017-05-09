From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [REEEEPOST] bnx2i + bnx2fc: convert to generic workqueue (#3)
Date: Tue, 09 May 2017 17:15:24 -0400
Message-ID: <yq1fugdratv.fsf@oracle.com>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
        <20170504174427.6hebbnqwfgems6dg@linutronix.de>
        <yq1inlass3y.fsf@oracle.com>
        <alpine.OSX.2.00.1705091015070.1067@administrators-MacBook-Pro.local>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51733 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdEIVPx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2017 17:15:53 -0400
In-Reply-To: <alpine.OSX.2.00.1705091015070.1067@administrators-MacBook-Pro.local>
        (Chad Dupuis's message of "Tue, 9 May 2017 10:17:03 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, QLogic-Storage-Upstream@qlogic.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>


Chad,

> To be honest, I'm reluctant to merge these patches on bnx2fc as the
> I/O path on this driver has been stable for quite some time and given
> that it's an older driver I'm not looking to make changes there.

I understand that the driver is in maintenance mode. However, the Linux
kernel and its interfaces are not. We do not offer any guarantees in
that department. So even if you do not intend to add new features to
bnx2fc, you will still need to keep it current wrt. the ongoing changes
in kernel interfaces (for better and for worse).

-- 
Martin K. Petersen	Oracle Linux Engineering
