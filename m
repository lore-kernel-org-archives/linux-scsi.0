From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Introduce BROKEN_ON_64BIT facility
Date: Mon, 02 Oct 2006 14:03:28 +0100
Message-ID: <1159794208.8907.9.camel@localhost.localdomain>
References: <20061002045512.GA8835@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50356 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S932342AbWJBN5x
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 09:57:53 -0400
In-Reply-To: <20061002045512.GA8835@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, chas@cmf.nrl.navy.mil, netdev@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de, mac@melware.de, markus.lidel@shadowconnect.com, samuel@sortiz.org, Neela.Kolli@engenio.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, thomas@winischhofer.net, ak@suse.de

Ar Llu, 2006-10-02 am 00:55 -0400, ysgrifennodd Jeff Garzik:
> Add a broken-on-64bit option, similar to the existing broken-on-smp
> config option.  This is just the first pass, marking the obvious
> candidates.

NAK. This contains lots of stuff whcih isn't broken in the first place.

(Eg Megaraid works with 32bit config tools not 64bit ones and is
otherwise fine, ISDN is just bogus warnings now swatted)

