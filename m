From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Date: Fri, 20 Jul 2007 18:46:23 +0100
Message-ID: <20070720174623.GA5547@linux-mips.org>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg> <20070720173132.GB19424@linux-mips.org> <20070720173359.GA22423@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935869AbXGTRq7@vger.kernel.org>
Received: from localhost.localdomain ([127.0.0.1]:9894 "EHLO
	dl5rb.ham-radio-op.net") by ftp.linux-mips.org with ESMTP
	id S20023031AbXGTRq1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>
	+ 2 others); Fri, 20 Jul 2007 18:46:27 +0100
Content-Disposition: inline
In-Reply-To: <20070720173359.GA22423@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 20, 2007 at 06:33:59PM +0100, Christoph Hellwig wrote:

> On Fri, Jul 20, 2007 at 06:31:32PM +0100, Ralf Baechle wrote:
> > > +#include <asm/irq.h>
> > 
> > These days that should probably be <linux/irq.h>.
> 
> Not at all, linux/irq.h is something entirely different.

Well, fine.  But checkpatch.pl will bitch about this and other files.
So one way or the other it's not quite kosher.

  Ralf
