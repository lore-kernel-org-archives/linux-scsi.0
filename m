From: Greg KH <greg@kroah.com>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 09:03:53 -0700
Message-ID: <20060626160353.GB3456@kroah.com>
References: <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org> <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru> <20060601132315.GD32143@parisc-linux.org> <1151270127.3617.26.camel@mulgrave.il.steeleye.com> <20060625224631.GD1608@parisc-linux.org> <1151310285.3185.16.camel@laptopd505.fenrus.org> <20060626124001.GG1608@parisc-linux.org> <1151326751.3185.37.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:60078 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750721AbWFZQHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 12:07:04 -0400
Content-Disposition: inline
In-Reply-To: <1151326751.3185.37.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>

On Mon, Jun 26, 2006 at 02:59:11PM +0200, Arjan van de Ven wrote:
> 
> > Fortunately, USB is SCSI, so we can actually use this code to solve that
> > problem too.  I wasn't thinking of USB when I wrote the code (because I
> > didn't know there was a problem).  But really, it's very generic stuff;
> > there's a list_head, a pointer to a Scsi_Host and a completion.
> > 
> > I'm not 100% sure what the problem is with USB. 
> 
> I seem to remember that the problem with USB was that you can't even
> know how many things are still outstanding; devices are free to appear
> on the bus at any time after bus power on, without specified timeout...
> If the kernel can't know what's out there, it can't wait until it has a
> complete picture either, just by virtue of not being able to know when
> that is achieved ;-)

This is true.

thanks,

greg k-h
