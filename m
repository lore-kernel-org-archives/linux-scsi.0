From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] SCSI core: Fix WRITE SAME handling
Date: Thu, 26 Jan 2017 09:24:53 +0100
Message-ID: <20170126082453.GA11768@lst.de>
References: <5bedd463-8f55-4506-0593-fd0040c47a17@sandisk.com> <20170125103725.GA18026@lst.de> <1485384261.2646.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46673 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752830AbdAZIY4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 03:24:56 -0500
Content-Disposition: inline
In-Reply-To: <1485384261.2646.8.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sagi@grimberg.me" <sagi@grimberg.me>

On Wed, Jan 25, 2017 at 10:44:41PM +0000, Bart Van Assche wrote:
> On Wed, 2017-01-25 at 11:37 +0100, Christoph Hellwig wrote:
> > > Fixes: f80de881d8df ("sd: remove __data_len hack for WRITE SAME")
> > 
> > I think the better fix is to simply revert this commit.
> 
> Hello Christoph,
> 
> Do you mean reverting commit f80de881d8df only for kernel release v4.10
> or also for future releases? How about resubmitting a reworked version of
> commit f80de881d8df for kernel v4.11?

Let's revert it for good for now.  This was a braino for me as the
real write same requests are very different from discards implemented
as write same.  I have a WIP series that would change a lot in this
area, so additional churn before that would not be productive.
