From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Fri, 09 Sep 2016 07:28:10 -0400
Message-ID: <yq1vay5fh2t.fsf@sermon.lab.mkp.net>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
        <20160908123943.f7n3lurs7ovs5pup@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48114 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753830AbcIIL2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 07:28:40 -0400
In-Reply-To: <20160908123943.f7n3lurs7ovs5pup@c203.arch.suse.de> (Johannes
        Thumshirn's message of "Thu, 8 Sep 2016 14:39:43 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

>> On Wed, Aug 17, 2016 at 12:09:59PM +0200, Sebastian Andrzej Siewior wrote:
>> The driver creates its own per-CPU threads which are updated based on
>> CPU hotplug events. It is also possible to use kworkers and remove
>> some of the infrastructure get the same job done while saving a few
>> lines of code.

Johannes> I'm sorry it took so long but for the whole series: Tested-by:
Johannes> Johannes Thumshirn <jth@kernel.org> Acked-by: Johannes
Johannes> Thumshirn <jth@kernel.org>

Johannes> Testing was conducted by booting from a QLogic BCM57840 CNA.

Chad?

-- 
Martin K. Petersen	Oracle Linux Engineering
