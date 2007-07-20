From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Date: Fri, 20 Jul 2007 11:34:48 -0600
Message-ID: <20070720173448.GH14791@parisc-linux.org>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg> <20070720173132.GB19424@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54266 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937677AbXGTRet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 13:34:49 -0400
Content-Disposition: inline
In-Reply-To: <20070720173132.GB19424@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, Russell King <rmk@arm.linux.org.uk>

On Fri, Jul 20, 2007 at 06:31:32PM +0100, Ralf Baechle wrote:
> On Fri, Jul 20, 2007 at 06:40:46PM +0200, Geert Uytterhoeven wrote:
> > +#include <asm/irq.h>
> 
> These days that should probably be <linux/irq.h>.

Go and read the comments at the top of linux/irq.h.
And then report to Russell for your whipping.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
