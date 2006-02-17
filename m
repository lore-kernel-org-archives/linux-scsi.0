From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Problems with MSI-X on ia64
Date: Fri, 17 Feb 2006 00:46:05 -0800
Message-ID: <20060217084605.GG4523@taniwha.stupidest.org>
References: <D4CFB69C345C394284E4B78B876C1CF10B848090@cceexc23.americas.cpqcorp.net> <20060217075829.GB22451@esmail.cup.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:54447 "HELO
	smtp103.sbc.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932576AbWBQIqH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 03:46:07 -0500
Content-Disposition: inline
In-Reply-To: <20060217075829.GB22451@esmail.cup.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <iod00d@hp.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>

On Thu, Feb 16, 2006 at 11:58:29PM -0800, Grant Grundler wrote:

> The root cause is the use of u32 to describe a PCI resource "start".
> phys_addr needs to be "unsigned long". More details in Log entry
> below.

That won't always suffice.

I have machines at work that will place some PCI resources above the
4GB boundary even when booting in '32-bit OS' mode (there is a BIOS
option for this but no matter the setting some resources always end up
above 4GB).  I've heard from others they've also been hit by this
(with 64-bit kernels it's fine).  I guess it could be argued that it's
a BIOS bug, I'm not entirely sure what to thing,  Windows seems to
deal with it.
