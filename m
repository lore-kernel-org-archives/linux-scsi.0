From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [REEEEPOST] bnx2i + bnx2fc: convert to generic workqueue (#3)
Date: Thu, 20 Apr 2017 22:24:43 +0200
Message-ID: <20170420202443.lryo4n7vobphezl2@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <alpine.OSX.2.00.1704101420150.1637@n8054ir3xxd7w1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:36924 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033682AbdDTUYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 16:24:54 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1704101420150.1637@n8054ir3xxd7w1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>

On 2017-04-10 14:20:41 [-0400], Chad Dupuis wrote:
> Sebastian, will take a look. 

This [0] commit in tip's smp/hotplug branch is staged for the next merge
window. It will trigger a lockdep warning on the recursive
get_online_cpus() invocation in the two drivers. It is fixed/avoided by
the series.

[0] https://git.kernel.org/tip/tip/c/d215aab82d81974f438bfbc80aa437132f3c37c3

Sebastian
