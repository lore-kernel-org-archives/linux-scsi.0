From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 09:15:40 +0200
Message-ID: <20050524071538.GX9855@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de> <4292D37C.5020700@pobox.com> <4292D44C.2040102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4292D44C.2040102@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 24 2005, Hannes Reinecke wrote:
> Jeff Garzik wrote:
> > Jens Axboe wrote:
> >> On Tue, May 24 2005, Jeff Garzik wrote:
> >>> I can describe how this will look when libata is divorced from SCSI,
> >>> if you would like, too...
> >>
> >> I was beginning to dispair you had given up that plan...
> > 
> > hehe, nope.  I promised Linus, and I plan to keep my promise :)
> > 
> > I know how to do it.  Internally things have been kept as separate as
> > possible from the SCSI layer.
> > 
> > Bart even hinted at possibly using libata-without-SCSI for future
> > /dev/hdX support.  It's certainly doable.
> > 
> AAArgh! No, not again!
> 
> We've finally succeeded in convincing everyone that having '/dev/sdX'
> instead of '/dev/hdX' was a neccessary step forward.
> I think we're getting shot if we now tell them to reverse this _again_.
> Can we at least have it optional?

Moving to /dev/sdX was never a step forward, it's was merely a necessary
side ways step because libata used the scsi layer. A step forward would
be device agnostic /dev/disk mappings instead.

> Or are you talking about linux-3.X ?

Hopefully before that :-)

-- 
Jens Axboe

