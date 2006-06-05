From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCHSET] block: fix PIO cache coherency bug, take 2
Date: Mon, 05 Jun 2006 10:47:40 -0500
Message-ID: <1149522460.3489.26.camel@mulgrave.il.steeleye.com>
References: <1149392479501-git-send-email-htejun@gmail.com>
	 <20060604204444.GF4484@flint.arm.linux.org.uk>
	 <20060604222347.GG4484@flint.arm.linux.org.uk>
	 <1149517656.3489.15.camel@mulgrave.il.steeleye.com>
	 <20060605144456.GA26666@flint.arm.linux.org.uk>
	 <1149521085.3489.24.camel@mulgrave.il.steeleye.com>
	 <20060605153420.GB26666@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060605153420.GB26666@flint.arm.linux.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <axboe@suse.de>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-06-05 at 16:34 +0100, Russell King wrote:
> What has zero copy (your reply) got to do with faulting pages into
> userspace (my message).  I'm sorry, I don't understand why you've
> brought this up.

The zero copy case is the case where we end up with user and kernel
mappings simultaneously on the page.  The nopage (or fault) case is
where we end up with them sequentially.  Both cases actually require the
same cache treatment, but it's easiest to understand in the zero copy
case.

James


