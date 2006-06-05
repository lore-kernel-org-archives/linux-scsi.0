From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCHSET] block: fix PIO cache coherency bug, take 2
Date: Mon, 5 Jun 2006 17:37:52 +0100
Message-ID: <20060605163752.GE26666@flint.arm.linux.org.uk>
References: <1149392479501-git-send-email-htejun@gmail.com> <20060604204444.GF4484@flint.arm.linux.org.uk> <20060604222347.GG4484@flint.arm.linux.org.uk> <1149517656.3489.15.camel@mulgrave.il.steeleye.com> <20060605144456.GA26666@flint.arm.linux.org.uk> <1149521085.3489.24.camel@mulgrave.il.steeleye.com> <20060605153420.GB26666@flint.arm.linux.org.uk> <1149522460.3489.26.camel@mulgrave.il.steeleye.com> <20060605154837.GD26666@flint.arm.linux.org.uk> <1149524202.3489.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1149524202.3489.30.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <axboe@suse.de>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 05, 2006 at 11:16:42AM -0500, James Bottomley wrote:
> On Mon, 2006-06-05 at 16:48 +0100, Russell King wrote:
> > When does the zero copy case occur?
> 
> Almost all user initiated I/O.  Glibc tends to implement this as mmap
> internally.

Ah, so you _are_ talking about something different from what I'm
talking about.  I'm concentrating _solely_ on the _read_ side,
and all my responses so far have been concerned about that only.

Anyway, I think this discussion has become meaningless since we've
been talking at cross purposes for the entire thread.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
