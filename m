From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16  commands to libata  ATAPI devices
Date: Thu, 4 Jan 2007 16:51:43 +0100
Message-ID: <20070104155143.GF11203@kernel.dk>
References: <200701021935.07840.liml@rtr.ca> <1167788405.3687.25.camel@mulgrave.il.steeleye.com> <459B4243.5080804@rtr.ca> <1167838307.2789.12.camel@mulgrave.il.steeleye.com> <459C066D.30507@torque.net> <1167860496.2789.70.camel@mulgrave.il.steeleye.com> <20070104150900.GD11203@kernel.dk> <459D1D49.3060909@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <459D1D49.3060909@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, dougg@torque.net, Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 04 2007, Mark Lord wrote:
> Jens Axboe wrote:
> >On Wed, Jan 03 2007, James Bottomley wrote:
> >>Er, well, as you know, I've never been a fan of this static list.  I
> >>thought Jens was going to put us all out of our misery by making the
> >>list settable per device by root and thus shovel the problem off onto
> >>the distros?
> >
> >The code is there, just haven't had the guts to merge it yet.
> >
> >http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=bf5f922d167a5c5cf57132bbcaa1e0ddfd5c45f7
> >
> 
> That's nice, but doesn't help with the case of trying to do ATA passthru
> to ATAPI devices, the subject of the original patch here.

James brought up the filtering issue, my reply pertains to that alone.
Hence the snipping of unrelated contents in the original mail :-)

-- 
Jens Axboe

