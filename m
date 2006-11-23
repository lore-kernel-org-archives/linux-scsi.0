From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] Kill dma_is_consistent()
Date: Thu, 23 Nov 2006 16:06:17 +0000
Message-ID: <20061123160617.GC8984@flint.arm.linux.org.uk>
References: <20061123150312.GA32406@linux-mips.org> <1164297574.2829.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:46347 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S933848AbWKWQGZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Nov 2006 11:06:25 -0500
Content-Disposition: inline
In-Reply-To: <1164297574.2829.9.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Nov 23, 2006 at 09:59:33AM -0600, James Bottomley wrote:
> On Thu, 2006-11-23 at 15:03 +0000, Ralf Baechle wrote:
> > dma_is_consistent() is ill-designed in that it does not have a struct device
> > argument which makes proper support for systems that consist of a mix of
> > coherent and non-coherent DMA devices hard.
> 
> At the time the interface was designed, the general consensus was that
> it was easier to recognise incoherent memory regions by their address
> range than by which device they came from.  The main proponent of this
> being arm, if I remember rightly.

I don't remember that being particularly discussed, and it seems that
no one has implemented it (but possibly implemented their own stuff
in arch private code.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
