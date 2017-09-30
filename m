From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V7 0/6] block/scsi: safe SCSI quiescing
Date: Sat, 30 Sep 2017 17:51:58 +0800
Message-ID: <20170930095157.GA28985@ming.t460p>
References: <20170930061214.10622-1-ming.lei@redhat.com>
 <8017332.HWsC7yeG6s@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8017332.HWsC7yeG6s@merkaba>
Sender: linux-block-owner@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

On Sat, Sep 30, 2017 at 11:47:10AM +0200, Martin Steigerwald wrote:
> Hi Ming.
> 
> Ming Lei - 30.09.17, 14:12:
> > Please consider this patchset for V4.15, and it fixes one
> > kind of long-term I/O hang issue in either block legacy path
> > or blk-mq.
> >
> > The current SCSI quiesce isn't safe and easy to trigger I/O deadlock.
> 
> Isn´t that material for -stable as well?

Yeah, the patch 6 is CCed to -stable.

> 
> I´d love to see this go into 4.14. Especially as its an LTS release.

I am fine with either 4.14 or 4.15, and it is up to Jens.

Thanks
Ming
