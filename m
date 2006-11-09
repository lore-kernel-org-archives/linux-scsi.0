From: "Wesley J. Landaker" <wjl@icecavern.net>
Subject: Re: Support for (new?) Silicon Image PCI SATA controller
Date: Thu, 9 Nov 2006 16:59:15 -0700
Message-ID: <200611091659.16002.wjl@icecavern.net>
References: <200611081803.52986.wjl@icecavern.net> <4553BBB3.1000508@gmail.com> <20061109234009.GT16952@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from c-68-54-3-45.hsd1.nm.comcast.net ([68.54.3.45]:27406 "EHLO
	icecavern.net") by vger.kernel.org with ESMTP id S1424266AbWKIX7W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Nov 2006 18:59:22 -0500
In-Reply-To: <20061109234009.GT16952@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tejun Heo <htejun@gmail.com>, linux-scsi@vger.kernel.org, Carlos Pardo <Carlos.Pardo@siliconimage.com>

On Thursday 09 November 2006 16:40, Matthew Wilcox wrote:
> On Fri, Nov 10, 2006 at 08:37:23AM +0900, Tejun Heo wrote:
> > >00:10.0 Mass storage controller [0180]: Silicon Image, Inc. Unknown
> > > device [1095:2502] (rev 01)
> > >        Subsystem: Silicon Image, Inc. Unknown device [1095:2512]
> >
> > SIMG says there's no such device and it's probably bad hardware
> > (probably a 3512) with stuck bits in PCI ID.  If you bought it, ask for
> > replacement.
>
> It could also be a problem with his motherboard.  I'd try it in a
> different slot (or in a different machine) before returning the card
> as bad.

Guys, thank you. Your suggestion about a stuck bit sounds reasonable, since I 
couldn't find any indication of any device IDs from SI that matched... that's 
why I originally assumed it was a new device (since the hardware is 
supposedly fairly recent).

I will try this out in a different motherboard slot and if there's no luck 
there see if I can get this card replaced.

Thank for the help, and hopefully I can get it working. =)

-- 
Wesley J. Landaker <wjl@icecavern.net>
