From: Jens Axboe <axboe@suse.de>
Subject: Re: Possible explanation for SCSI benchmark problems in 2.5
Date: Mon, 30 Sep 2002 09:47:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020930074702.GD27420@suse.de>
References: <200209292048.g8TKmN424799@localhost.localdomain> <3D976864.65C82D7B@digeo.com> <20020930073033.GA27420@suse.de> <3D980142.971B70AD@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D980142.971B70AD@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Sep 30 2002, Andrew Morton wrote:
> Jens Axboe wrote:
> > 
> > On Sun, Sep 29 2002, Andrew Morton wrote:
> > > But high-IO is bust for IDE as well at present, so at least
> > > we're being fair ;)
> > 
> > Nah that's fixed, it worries me that you say otherwise. Doesn't it work
> > for you in stock 2.5.39?
> > 
> 
> Ah you're right, it went away.  I was assuming that it was still
> a problem because my fixit patch wasn't throwing rejects...

I _think_ we should have that patch in addition (it seems noone calls
pci_set_dma_mask on the ide pci dev). At least it cannot hurt, so feel
free to pass it along.

-- 
Jens Axboe

