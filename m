From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Thu, 12 Aug 2004 21:11:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040812191120.GA14903@elf.ucw.cz>
References: <4119611D.60401@optonline.net> <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net> <1092231462.2087.3.camel@mulgrave> <1092267400.2136.24.camel@gaston> <1092314892.1755.5.camel@mulgrave> <20040812131457.GB1086@elf.ucw.cz> <1092328173.2184.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs214-76.eurotel.cz ([160.218.214.76]:59013 "EHLO amd.ucw.cz")
	by vger.kernel.org with ESMTP id S264147AbUHLTLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 15:11:39 -0400
Content-Disposition: inline
In-Reply-To: <1092328173.2184.15.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Nathan Bryant <nbryant@optonline.net>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

Hi!

> > Even read-only access could hurt.... That DMA engine is going to get
> > very unhappy if we change data from under it, right?
> 
> But we're not planning to change this area of memory (it's a driver
> allocated coherent mbox) until we power off the box, right? so it should
> be just like a reboot today.

Ok, but what happens on next resume? If coherent mbox is at exactly
same place at every boot I guess it could even work, but...
								Pavel
-- 
People were complaining that M$ turns users into beta-testers...
...jr ghea gurz vagb qrirybcref, naq gurl frrz gb yvxr vg gung jnl!
