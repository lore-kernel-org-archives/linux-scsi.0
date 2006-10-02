From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Introduce BROKEN_ON_64BIT facility
Date: Mon, 02 Oct 2006 17:21:11 +0100
Message-ID: <1159806071.8907.28.camel@localhost.localdomain>
References: <200610021352.k92DqRwa015220@cmf.nrl.navy.mil>
	 <1159801956.8907.13.camel@localhost.localdomain>
	 <20061002151853.GK16272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20061002151853.GK16272@parisc-linux.org>
Sender: netdev-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: chas3@users.sourceforge.net, Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de, mac@melware.de, markus.lidel@shadowconnect.com, samuel@sortiz.org, Neela.Kolli@engenio.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, thomas@winischhofer.net, ak@suse.de
List-Id: linux-scsi@vger.kernel.org

> (whitespace damaged; more for comment than for application).
> 
> > -        if ((u32)skb->data & 3) {
> > +        if ((unsigned long)skb->data & 3) {
> 
> I suppose it quietens a compiler warning.  Doesn't actually fix a bug
> though.

Right but it does no harm casting it to either so its worth cleaning up.

