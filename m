From: Greg KH <greg@kroah.com>
Subject: Re: bug 2400
Date: Thu, 8 Apr 2004 16:06:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040408230656.GO15125@kroah.com>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave> <20040404213307.A29446@beaverton.ibm.com> <1081199233.2105.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:7349 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261790AbUDIFvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 01:51:46 -0400
Content-Disposition: inline
In-Reply-To: <1081199233.2105.45.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Apr 05, 2004 at 04:07:12PM -0500, James Bottomley wrote:
> On Sun, 2004-04-04 at 23:33, Patrick Mansfield wrote:
> > How is unregister_cdrom(&cd->cdi) called if the device is not open?
> 
> OK, the attached does everything correctly (as I should have done at
> first) by using a kobject to hold the compound references.

Why not just use a kref for this?  That's what they were created for?
:)

thanks,

greg k-h
