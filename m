From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.18-mm2
Date: Fri, 29 Sep 2006 18:15:42 +0100
Message-ID: <1159550143.13029.36.camel@localhost.localdomain>
References: <20060928014623.ccc9b885.akpm@osdl.org>
	 <20060929155738.7076f0c8@werewolf> <20060929143949.GL5017@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56547 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S932366AbWI2Quw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Sep 2006 12:50:52 -0400
In-Reply-To: <20060929143949.GL5017@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "J.A. Magall??n" <jamagallon@ono.com>, Andrew Morton <akpm@osdl.org>, "Linux-Kernel," <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Ar Gwe, 2006-09-29 am 08:39 -0600, ysgrifennodd Matthew Wilcox:
> On Fri, Sep 29, 2006 at 03:57:38PM +0200, J.A. Magall??n wrote:
> > aic7xxx oopses on boot:
> > 
> > PCI: Setting latency timer of device 0000:00:0e.0 to 64
> > IRQ handler type mismatch for IRQ 0
> 
> Of course, this isn't a scsi problem, it's a peecee hardware problem.
> Or maybe a PCI subsystem problem.  But it's clearly not aic7xxx's fault.

AIC7xxx finding it has no IRQ configured is valid (annoying, stupid and
valid) so the driver should check before requesting "no IRQ"

