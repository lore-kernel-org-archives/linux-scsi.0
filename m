From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptsas, msi and the dl585 g2
Date: Thu, 09 Jul 2009 15:40:44 -0500
Message-ID: <1247172044.3898.147.camel@mulgrave.site>
References: <20090630180300.GA9971@ldl.fc.hp.com>
	 <4A4A5B01.9040200@kernel.org> <20090703225708.GA30664@ldl.fc.hp.com>
	 <4A4FADDC.30606@kernel.org> <20090709185945.GG2613@ldl.fc.hp.com>
	 <4A564263.5010305@kernel.org> <4A564634.1020708@kernel.org>
	 <4A564990.3060202@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51974 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970AbZGIUkt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 16:40:49 -0400
In-Reply-To: <4A564990.3060202@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: dann frazier <dannf@hp.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, 2009-07-09 at 12:48 -0700, Yinghai Lu wrote:
> [    4.333140]   PREFETCH window: 0x00000000d9f00000-0x00000000d9ffffff
> are all directed to one 8132 PCI-X bridge.
> 
> the the IOAPIC for 9, 10, 11... falling that range...
> 
> we need one better to allocate range for that pci-x bridge to aovide ioapic BAR allocated...
> 
> anyway your BIOS sucks.

It's a sad and very annoying fact of life that most BIOSs suck.  If they
didn't suck, our bios handling code wouldn't be a nasty mess of
exceptions, work arounds and quirks.

Can we fix this so that both the DL585 and the opteron multi root stuff
can work?  There's a large population of DL585's out there, so we can't
release 2.6.32 like this ... and I'd rather not have to choose between
breaking the DL585's and breaking the Sun Opterons.

James




