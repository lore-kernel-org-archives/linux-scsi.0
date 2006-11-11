From: Dave Jones <davej@redhat.com>
Subject: Re: Support for (new?) Silicon Image PCI SATA controller
Date: Sat, 11 Nov 2006 17:47:24 -0500
Message-ID: <20061111224724.GA13292@redhat.com>
References: <200611081803.52986.wjl@icecavern.net> <4553BBB3.1000508@gmail.com> <20061109234009.GT16952@parisc-linux.org> <200611091659.16002.wjl@icecavern.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:13721 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1754888AbWKKWrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Nov 2006 17:47:40 -0500
Content-Disposition: inline
In-Reply-To: <200611091659.16002.wjl@icecavern.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wesley J. Landaker" <wjl@icecavern.net>
Cc: Matthew Wilcox <matthew@wil.cx>, Tejun Heo <htejun@gmail.com>, linux-scsi@vger.kernel.org, Carlos Pardo <Carlos.Pardo@siliconimage.com>

On Thu, Nov 09, 2006 at 04:59:15PM -0700, Wesley J. Landaker wrote:

 > > > SIMG says there's no such device and it's probably bad hardware
 > > > (probably a 3512) with stuck bits in PCI ID.  If you bought it, ask for
 > > > replacement.
 > > It could also be a problem with his motherboard.  I'd try it in a
 > > different slot (or in a different machine) before returning the card
 > > as bad.
 > 
 > Guys, thank you. Your suggestion about a stuck bit sounds reasonable, since I 
 > couldn't find any indication of any device IDs from SI that matched... that's 
 > why I originally assumed it was a new device (since the hardware is 
 > supposedly fairly recent).
 > 
 > I will try this out in a different motherboard slot and if there's no luck 
 > there see if I can get this card replaced.
 > 
 > Thank for the help, and hopefully I can get it working. =)

I've seen similar things from cards with dirty connectors.
A pencil eraser over the contacts made a similar problem I saw
with a tulip card disappear.

		Dave

-- 
http://www.codemonkey.org.uk
