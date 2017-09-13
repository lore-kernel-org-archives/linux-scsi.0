From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4 08/10] block: allow to allocate req with RQF_PREEMPT
 when queue is preempt frozen
Date: Thu, 14 Sep 2017 01:48:00 +0800
Message-ID: <20170913174759.GB24862@ming.t460p>
References: <20170911111021.25810-1-ming.lei@redhat.com>
 <20170911111021.25810-9-ming.lei@redhat.com>
 <1505145834.2802.17.camel@wdc.com>
 <20170912034057.GC31533@ming.t460p>
 <20170913164803.GB10407@ming.t460p>
 <1505323703.2654.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdIMRsQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 13:48:16 -0400
Content-Disposition: inline
In-Reply-To: <1505323703.2654.3.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "cavery@redhat.com" <cavery@redhat.com>

On Wed, Sep 13, 2017 at 05:28:24PM +0000, Bart Van Assche wrote:
> On Thu, 2017-09-14 at 00:48 +0800, Ming Lei wrote:
> > Could you please let me know if your concern about race between
> > preempt freeze and blk_cleanup_queue() is addressed in my last
> > reply?
> 
> Shouldn't we wait until v4.13-rc1 has been released before spending more
> energy on this? Certain patches that have been sent to Linus, e.g. commit

The discussion should have been done any time, right?

I believe I replied all your comments, if you don't agree any one of
my follow-up, please point it out.

> 157f377beb71 ("block: directly insert blk-mq request from
> blk_insert_cloned_request()"), may affect the test results. I have not

No, that patch only changes blk_insert_cloned_request() which is used
by dm-rq(mpath) only, nothing to do with the reported issue during
suspend and sending SCSI Domain validation.


-- 
Ming
