From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Thu, 12 Aug 2004 22:48:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040812204838.GH14556@elf.ucw.cz>
References: <1092267400.2136.24.camel@gaston> <1092314892.1755.5.camel@mulgrave> <20040812131457.GB1086@elf.ucw.cz> <1092328173.2184.15.camel@mulgrave> <20040812191120.GA14903@elf.ucw.cz> <1092339247.1755.36.camel@mulgrave> <20040812202622.GD14556@elf.ucw.cz> <1092342716.2184.56.camel@mulgrave> <20040812203729.GE14556@elf.ucw.cz> <1092343376.1755.61.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs214-76.eurotel.cz ([160.218.214.76]:4998 "EHLO amd.ucw.cz")
	by vger.kernel.org with ESMTP id S268774AbUHLUs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 16:48:58 -0400
Content-Disposition: inline
In-Reply-To: <1092343376.1755.61.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Nathan Bryant <nbryant@optonline.net>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

Hi!

> > Can't you simply reuse bootup code? It will no longer be __init,
> > but it should make suspend/resume functions quite simple.
> 
> Unfortunately, no that simply.
> 
> Bootup is all about allocating these areas and initialising the card. 
> Resume will be about initialising the card knowing the existing areas
> (and the data about the existing areas will have to be part of our
> persistent data on suspend).

You can simply free those areas during suspend, so that resume will be
same as powerup....

Essentially if you can do insmod and rmmod, you can "simply" emulate
rmmod during suspend and emulate "insmod" during resume...

> > > to pick three drivers to do this for, that would be aic7xxx, aic79xx and
> > > sym_2?
> > 
> > No idea, only SCSI host I owned was some 8-bit isa thing....
> 
> Well, someone who's interested needs to pick a driver.  It's usually
> easier to persuade everyone to add the feature if there's an example to
> copy...

Make it aic7xxx then... Someone already worked on that one.

									Pavel
-- 
People were complaining that M$ turns users into beta-testers...
...jr ghea gurz vagb qrirybcref, naq gurl frrz gb yvxr vg gung jnl!
