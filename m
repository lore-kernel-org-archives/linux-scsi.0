From: Greg KH <greg@kroah.com>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 09:02:50 -0700
Message-ID: <20060626160250.GA3456@kroah.com>
References: <20060529130515.GE23405@parisc-linux.org> <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru> <20060601132315.GD32143@parisc-linux.org> <1151270127.3617.26.camel@mulgrave.il.steeleye.com> <20060625224631.GD1608@parisc-linux.org> <1151310285.3185.16.camel@laptopd505.fenrus.org> <20060626124001.GG1608@parisc-linux.org> <20060626144442.GA13319@one-eyed-alien.net> <20060626151828.GH1608@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:56238 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750732AbWFZQGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 12:06:49 -0400
Content-Disposition: inline
In-Reply-To: <20060626151828.GH1608@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-hotplug-devel@lists.sourceforge.net, Patrick Mansfield <patmans@us.ibm.com>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, James Bottomley <James.Bottomley@SteelEye.com>

On Mon, Jun 26, 2006 at 09:18:28AM -0600, Matthew Wilcox wrote:
> On Mon, Jun 26, 2006 at 07:44:42AM -0700, Matthew Dharm wrote:
> > Second, depending on how many hubs are between the host and target, the
> > time-to-discover the device is highly variable.
> 
> Can, or does, USB keep track of hub discovery, and hence know whether
> or not it's completed USB discovery?

Nope, it never knows this.  So that is why you can't have any type of
"just wait until USB is done scanning all devices before continuing"
behavior, because there is no such thing to trigger off of.

sorry,

greg k-h
