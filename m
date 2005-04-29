From: Greg KH <greg@kroah.com>
Subject: Re: [06/07] [PATCH] SCSI tape security: require CAP_ADMIN for SG_IO etc.
Date: Thu, 28 Apr 2005 21:20:15 -0700
Message-ID: <20050429042014.GC25474@kroah.com>
References: <20050427171446.GA3195@kroah.com> <20050427171649.GG3195@kroah.com> <1114619928.18809.118.camel@localhost.localdomain> <Pine.LNX.4.61.0504280810140.12812@kai.makisara.local> <1114694511.18809.187.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:29860 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262381AbVD2EUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 00:20:44 -0400
Content-Disposition: inline
In-Reply-To: <1114694511.18809.187.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Greg KH <gregkh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Cliff White <cliffw@osdl.org>, Theodore Ts'o <tytso@mit.edu>, "Randy.Dunlap" <rddunlap@osdl.org>, Chuck Wolber <chuckw@quantumlinux.com>, torvalds@osdl.org, Andrew Morton <akpm@osdl.org>

On Thu, Apr 28, 2005 at 02:21:52PM +0100, Alan Cox wrote:
> On Iau, 2005-04-28 at 06:43, Kai Makisara wrote:
> > Any user having write access to the device is still allowed to send MODE 
> > SELECT (and some other commands useful for CD/DVD writers but being 
> > potentially dangerous to other). The assumption that _any_ command needed 
> > for burning CDs/DVDs is safe for all device types is ridiculous. This is 
> > why I don't consider the refinements useful.
> 
> Ok thats the bit I needed to know

So, do you still object to this patch being accepted?

thanks,

greg k-h
