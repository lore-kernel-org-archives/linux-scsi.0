From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Fri, 30 Sep 2016 23:43:47 +0200
Message-ID: <20160930214347.c7xzlmbs2ikd2b3b@linutronix.de>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
 <20160908123943.f7n3lurs7ovs5pup@c203.arch.suse.de>
 <yq1vay5fh2t.fsf@sermon.lab.mkp.net>
 <alpine.OSX.2.00.1609130927440.483@administrators-macbook-pro.local>
 <yq137l2mm13.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:58992 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933120AbcI3Vn4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2016 17:43:56 -0400
Content-Disposition: inline
In-Reply-To: <yq137l2mm13.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>

On 2016-09-14 13:25:12 [-0400], Martin K. Petersen wrote:
> >>>>> "Chad" == Chad Dupuis <chad.dupuis@cavium.com> writes:
> 
> Chad> We're regression testing the patches now.  Please hold off on
> Chad> applying them.
> 
> OK. I will wait.

Chad, any updates on this tests?

Sebastian
