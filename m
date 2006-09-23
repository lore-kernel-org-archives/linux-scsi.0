From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Date: Fri, 22 Sep 2006 17:57:33 -0700
Message-ID: <20060922175733.522c9e0b.rdunlap@xenotime.net>
References: <20060921231314.GW29167@austin.ibm.com>
	<20060922220629.GA4600@dreamland.darkstar.lan>
	<20060922233235.GB14213@austin.ibm.com>
	<20060922163929.bb870ee1.rdunlap@xenotime.net>
	<20060922235017.GD14213@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:44500 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S964989AbWIWA4Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 20:56:24 -0400
Received: from midway.site ([71.117.233.155]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 17:56:22 -0700
In-Reply-To: <20060922235017.GD14213@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Luca <kronos.it@gmail.com>, linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org

On Fri, 22 Sep 2006 18:50:17 -0500 Linas Vepstas wrote:

> On Fri, Sep 22, 2006 at 04:39:29PM -0700, Randy.Dunlap wrote:
> > On Fri, 22 Sep 2006 18:32:35 -0500 Linas Vepstas wrote:
> > 
> > > On Sat, Sep 23, 2006 at 12:06:29AM +0200, Luca wrote:
> > > > 
> > > > Space after function name? You put in other places too, it's not
> > > > consistent with the rest of the patch.
> > > 
> > > Oops. I was also coding on a different project recently, with a
> > > different style.  I'll send a revised patch in a moment.
> > 
> > Please change if()'s to use
> > 
> > 	if (var == constant)
> > instead of
> > 	if (constant == var)
> 
> Yuck! Horrid coding style! No rational excuse for coding like that.
> Advice taken under protest; new patch shortly.

Just after my email, I saw this :)
http://marc.theaimsgroup.com/?l=linux-mm-commits&m=115896769322020&w=2

---
~Randy
