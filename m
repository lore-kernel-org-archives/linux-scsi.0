From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [REEEEPOST] bnx2i + bnx2fc: convert to generic workqueue (#3)
Date: Thu, 4 May 2017 19:44:28 +0200
Message-ID: <20170504174427.6hebbnqwfgems6dg@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:53632 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbdEDRof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2017 13:44:35 -0400
Content-Disposition: inline
In-Reply-To: <20170410171254.30367-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, QLogic-Storage-Upstream@qlogic.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@cavium.com>

On 2017-04-10 19:12:49 [+0200], To Martin K . Petersen wrote:
> This is a repost to get the patches applied against v4.11-rc6. mkp's scsi
> for-next tree can be merged with no conflicts.
…

Martin, do you see any chance to get this merged? Chad replied to the
list that he is going to test it on 2017-04-10, didn't respond to the
ping 10 days later. The series stalled last time in the same way.

> The whole series is also available at
>  git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/hotplug-staging.git scsi/bnx2_v2
 
Sebastian
