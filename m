From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.18-mm2
Date: Fri, 29 Sep 2006 08:39:49 -0600
Message-ID: <20060929143949.GL5017@parisc-linux.org>
References: <20060928014623.ccc9b885.akpm@osdl.org> <20060929155738.7076f0c8@werewolf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53206 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1750834AbWI2Ojv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Sep 2006 10:39:51 -0400
Content-Disposition: inline
In-Reply-To: <20060929155738.7076f0c8@werewolf>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "J.A. Magall??n" <jamagallon@ono.com>
Cc: Andrew Morton <akpm@osdl.org>, "Linux-Kernel, " <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Fri, Sep 29, 2006 at 03:57:38PM +0200, J.A. Magall??n wrote:
> aic7xxx oopses on boot:
> 
> PCI: Setting latency timer of device 0000:00:0e.0 to 64
> IRQ handler type mismatch for IRQ 0

Of course, this isn't a scsi problem, it's a peecee hardware problem.
Or maybe a PCI subsystem problem.  But it's clearly not aic7xxx's fault.

> PCI: Cannot allocate resource region 0 of device 0000:00:0e.0

That's not good.  Might be part of the problem.

> PCI: Enabling device 0000:00:0e.0 (0000 -> 0003)
> PCI: No IRQ known for interrupt pin A of device 0000:00:0e.0. Probably buggy MP table.

This is the direct problem.  You've got no irq.

