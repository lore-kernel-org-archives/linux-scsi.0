From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] sun3x_esp: convert to esp_scsi
Date: Mon, 11 Feb 2008 09:18:26 -0600
Message-ID: <1202743106.3122.5.camel@localhost.localdomain>
References: <200802080259.m182xDkb014716@hera.kernel.org>
	 <Pine.LNX.4.64.0802080932220.18242@anakin>
	 <1202636295.2814.31.camel@kars.perseus.home>
	 <20080211112453.GA7761@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43594 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708AbYBKPSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 10:18:32 -0500
In-Reply-To: <20080211112453.GA7761@alpha.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Kars de Jong <jongk@linux-m68k.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2008-02-11 at 12:24 +0100, Thomas Bogendoerfer wrote:
> On Sun, Feb 10, 2008 at 10:38:15AM +0100, Kars de Jong wrote:
> > Thomas, can't you use ioreadxx() and friends instead of rolling your own
> > memory mapped I/O handlers?
> 
> well, at least ioread32be/iowrite32be are looking promising, but a quick
> grep didn't show them for m68k.

Someone could submit a patch ...

> > readxx() and friends are only to be used on PCI-like buses.
> 
> hmm, afaik readxx/writexx is not directly related to PCI. It's
> like ioread/iowrite to access iomapped address space. The difference
> to ioread/iowrite is that it doesn't support PCI IO space.

That's correct ... at least that's the meaning we've ascribed on other
architectures I've worked on. Any ioremap'd memory area can be accessed
by readX/writeX.  The current list of Buses I know it works on is MCA,
EISA, GSC, Runway ... in addition to PCI.

James


