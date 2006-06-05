From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCHSET] block: fix PIO cache coherency bug, take 2
Date: Mon, 5 Jun 2006 16:34:20 +0100
Message-ID: <20060605153420.GB26666@flint.arm.linux.org.uk>
References: <1149392479501-git-send-email-htejun@gmail.com> <20060604204444.GF4484@flint.arm.linux.org.uk> <20060604222347.GG4484@flint.arm.linux.org.uk> <1149517656.3489.15.camel@mulgrave.il.steeleye.com> <20060605144456.GA26666@flint.arm.linux.org.uk> <1149521085.3489.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1149521085.3489.24.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <axboe@suse.de>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 05, 2006 at 10:24:44AM -0500, James Bottomley wrote:
> On Mon, 2006-06-05 at 15:44 +0100, Russell King wrote:
> > Hence I find your comment "There are two cases where devices kmap a
> > user page into kernel space and then proceed to read from or write to
> > it" to be misleading - at the exact point in time that the device
> > driver is manipulating the data in that page, it is not a user page.
> 
> zero copy doesn't quite follow that ownership model.

What has zero copy (your reply) got to do with faulting pages into
userspace (my message).  I'm sorry, I don't understand why you've
brought this up.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
