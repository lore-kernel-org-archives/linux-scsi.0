From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Date: Fri, 20 Jul 2007 11:50:50 -0600
Message-ID: <20070720175050.GI14791@parisc-linux.org>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg> <20070720173132.GB19424@linux-mips.org> <20070720173359.GA22423@infradead.org> <46A0F453.60005@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43310 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXGTRuw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 13:50:52 -0400
Content-Disposition: inline
In-Reply-To: <46A0F453.60005@ru.mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ralf Baechle <ralf@linux-mips.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org

On Fri, Jul 20, 2007 at 09:43:47PM +0400, Sergei Shtylyov wrote:
> Hello Christoph:
> 
> >>>+#include <asm/irq.h>
> 
> >>These days that should probably be <linux/irq.h>.
> 
> >Not at all, linux/irq.h is something entirely different.
> 
>    Actually, <linux/interrupt.h>

Not for enable/disable_irq.  For request_irq, yes.

This is something that should be fixed.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
