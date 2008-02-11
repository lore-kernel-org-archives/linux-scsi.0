From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [SCSI] sun3x_esp: convert to esp_scsi
Date: Mon, 11 Feb 2008 12:24:53 +0100
Message-ID: <20080211112453.GA7761@alpha.franken.de>
References: <200802080259.m182xDkb014716@hera.kernel.org> <Pine.LNX.4.64.0802080932220.18242@anakin> <1202636295.2814.31.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:56621 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbYBKLZE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 06:25:04 -0500
Content-Disposition: inline
In-Reply-To: <1202636295.2814.31.camel@kars.perseus.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Feb 10, 2008 at 10:38:15AM +0100, Kars de Jong wrote:
> Thomas, can't you use ioreadxx() and friends instead of rolling your own
> memory mapped I/O handlers?

well, at least ioread32be/iowrite32be are looking promising, but a quick
grep didn't show them for m68k.

> readxx() and friends are only to be used on PCI-like buses.

hmm, afaik readxx/writexx is not directly related to PCI. It's
like ioread/iowrite to access iomapped address space. The difference
to ioread/iowrite is that it doesn't support PCI IO space.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
