From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Date: Fri, 22 Sep 2006 18:50:17 -0500
Message-ID: <20060922235017.GD14213@austin.ibm.com>
References: <20060921231314.GW29167@austin.ibm.com> <20060922220629.GA4600@dreamland.darkstar.lan> <20060922233235.GB14213@austin.ibm.com> <20060922163929.bb870ee1.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:64916 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S964943AbWIVXuT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 19:50:19 -0400
Content-Disposition: inline
In-Reply-To: <20060922163929.bb870ee1.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Luca <kronos.it@gmail.com>, linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org

On Fri, Sep 22, 2006 at 04:39:29PM -0700, Randy.Dunlap wrote:
> On Fri, 22 Sep 2006 18:32:35 -0500 Linas Vepstas wrote:
> 
> > On Sat, Sep 23, 2006 at 12:06:29AM +0200, Luca wrote:
> > > 
> > > Space after function name? You put in other places too, it's not
> > > consistent with the rest of the patch.
> > 
> > Oops. I was also coding on a different project recently, with a
> > different style.  I'll send a revised patch in a moment.
> 
> Please change if()'s to use
> 
> 	if (var == constant)
> instead of
> 	if (constant == var)

Yuck! Horrid coding style! No rational excuse for coding like that.
Advice taken under protest; new patch shortly.

--linas

