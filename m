From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Thu, 12 Aug 2004 15:14:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040812131457.GB1086@elf.ucw.cz>
References: <4119611D.60401@optonline.net> <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net> <1092231462.2087.3.camel@mulgrave> <1092267400.2136.24.camel@gaston> <1092314892.1755.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs214-235.eurotel.cz ([160.218.214.235]:35205 "EHLO
	amd.ucw.cz") by vger.kernel.org with ESMTP id S268560AbUHLNPZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 09:15:25 -0400
Content-Disposition: inline
In-Reply-To: <1092314892.1755.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Nathan Bryant <nbryant@optonline.net>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

Hi!

> > Some hosts will continuously DMA to memory iirc.. I remember having a
> > problem with 53c8xx on some macs when transitionning from MacOS to Linux
> > because of that.
> 
> I think you're thinking of the scripts engine?  on pre 53c875 chips,
> yes, this is true.  The on-board processor is executing instructions
> from host memory.  However, this is read only in quiescent (waiting for
> host connect or target reconnect) mode, so shouldn't be a problem for
> suspend.  On the 875 and later, we host the scripts in on-chip memory so
> they shouldn't be troubling main memory when idling.

Even read-only access could hurt.... That DMA engine is going to get
very unhappy if we change data from under it, right?


								Pavel
-- 
People were complaining that M$ turns users into beta-testers...
...jr ghea gurz vagb qrirybcref, naq gurl frrz gb yvxr vg gung jnl!
