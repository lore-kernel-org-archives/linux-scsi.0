From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Tue, 13 Sep 2016 09:28:14 -0400
Message-ID: <alpine.OSX.2.00.1609130927440.483@administrators-macbook-pro.local>
References: <20160817101003.30055-1-bigeasy@linutronix.de> <20160908123943.f7n3lurs7ovs5pup@c203.arch.suse.de> <yq1vay5fh2t.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0065.outbound.protection.outlook.com ([104.47.36.65]:53806
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755164AbcIMSB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Sep 2016 14:01:56 -0400
In-Reply-To: <yq1vay5fh2t.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>


On Fri, 9 Sep 2016, 11:28am -0000, Martin K. Petersen wrote:

> >>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:
> 
> >> On Wed, Aug 17, 2016 at 12:09:59PM +0200, Sebastian Andrzej Siewior
> wrote:
> >> The driver creates its own per-CPU threads which are updated based on
> >> CPU hotplug events. It is also possible to use kworkers and remove
> >> some of the infrastructure get the same job done while saving a few
> >> lines of code.
> 
> Johannes> I'm sorry it took so long but for the whole series: Tested-by:
> Johannes> Johannes Thumshirn <jth@kernel.org> Acked-by: Johannes
> Johannes> Thumshirn <jth@kernel.org>
> 
> Johannes> Testing was conducted by booting from a QLogic BCM57840 CNA.
> 
> Chad?
> 

We're regression testing the patches now.  Please hold off on applying 
them. 
