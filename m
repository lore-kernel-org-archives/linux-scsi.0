From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Add compat_ioctl to st
Date: 18 Jan 2005 13:30:24 +0100
Message-ID: <20050118123024.GA68224@muc.de>
References: <20050118110613.GC43344@muc.de> <20050118122524.GN30982@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:30219 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261278AbVARMa0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 07:30:26 -0500
Date: Tue, 18 Jan 2005 13:30:24 +0100
Content-Disposition: inline
In-Reply-To: <20050118122524.GN30982@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@SteelEye.com, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

> How about having a macro ...
> 
> 	.ioctl =	st_ioctl,
> 	COMPAT_IOCTL_ENTRY(st_compat_ioctl)
> 	.open =		st_open,
> 
> which could be defined something like:
> 
> #ifdef CONFIG_COMPAT
> #define COMPAT_IOCTL_ENTRY(x)	.compat_ioctl = x,
> #else
> #define COMPAT_IOCTL_ENTRY(x)	/* */
> #endif

To be honest I prefer the ifdef. It makes it clear 
what is going on, without any unneeded abstraction.
The macro in comparison looks unnatural in the definition
block.

-Andi
