From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [REEEEPOST] bnx2i + bnx2fc: convert to generic workqueue (#3)
Date: Mon, 10 Apr 2017 14:20:41 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1704101420150.1637@n8054ir3xxd7w1.qlogic.org>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0087.outbound.protection.outlook.com ([104.47.41.87]:2896
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752999AbdDJSVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 14:21:05 -0400
In-Reply-To: <20170410171254.30367-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>


On Mon, 10 Apr 2017, 5:12pm -0000, Sebastian Andrzej Siewior wrote:

> This is a repost to get the patches applied against v4.11-rc6. mkp's scsi
> for-next tree can be merged with no conflicts.
> 
> The last repost [0] was not merged and stalled after Martin pinged Chad
> [1]. He didn't even reply after tglx pinged him approx two weeks later.
> 
> Johannes Thumshirn was so kind to test the FCoE part of the old series
> [2]. I did not add a tested-by tag due to the rebase.
> 
> If my memory is correct then my first attempt on this (with hotplug
> threads back then) was around December 2015.
> 
> The whole series is also available at
>  git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/hotplug-staging.git scsi/bnx2_v2
> 
> [0] http://www.spinics.net/lists/linux-scsi/msg102143.html
> [1] http://www.spinics.net/lists/linux-scsi/msg102295.html
> [2] http://www.spinics.net/lists/linux-scsi/msg102716.html
> 
> Sebastian
> 

Sebastian, will take a look. 
