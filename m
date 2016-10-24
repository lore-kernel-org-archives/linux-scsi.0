From: Omar Sandoval <osandov@osandov.com>
Subject: Re: Device or HBA level QD throttling creates randomness in
 sequetial workload
Date: Mon, 24 Oct 2016 08:41:23 -0700
Message-ID: <20161024154123.GA7379@vader>
References: <97184c74229af78b0d97e6b8016af972@mail.gmail.com>
 <20161021213121.GA10030@vader.DHCP.thefacebook.com>
 <1f7cec69e6e12b6baa8e7f180a8e41b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1f7cec69e6e12b6baa8e7f180a8e41b3@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 24, 2016 at 06:35:01PM +0530, Kashyap Desai wrote:
> >
> > On Fri, Oct 21, 2016 at 05:43:35PM +0530, Kashyap Desai wrote:
> > > Hi -
> > >
> > > I found below conversation and it is on the same line as I wanted some
> > > input from mailing list.
> > >
> > > http://marc.info/?l=linux-kernel&m=147569860526197&w=2
> > >
> > > I can do testing on any WIP item as Omar mentioned in above
> discussion.
> > > https://github.com/osandov/linux/tree/blk-mq-iosched
> 
> I tried build kernel using this repo, but looks like it is not allowed to
> reboot due to some changes in <block> layer.

Did you build the most up-to-date version of that branch? I've been
force pushing to it, so the commit id that you built would be useful.
What boot failure are you seeing?

> >
> > Are you using blk-mq for this disk? If not, then the work there won't
> affect you.
> 
> YES. I am using blk-mq for my test. I also confirm if use_blk_mq is
> disable, Sequential work load issue is not seen and <cfq> scheduling works
> well.

Ah, okay, perfect. Can you send the fio job file you're using? Hard to
tell exactly what's going on without the details. A sequential workload
with just one submitter is about as easy as it gets, so this _should_ be
behaving nicely.

> >
> > > Is there any workaround/alternative in latest upstream kernel, if user
> > > wants to see limited penalty  for Sequential Work load on HDD ?
> > >
> > > ` Kashyap
> > >

P.S., your emails are being marked as spam by Gmail. Actually, Gmail
seems to mark just about everything I get from Broadcom as spam due to
failed DMARC.

-- 
Omar
