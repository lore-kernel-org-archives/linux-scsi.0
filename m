From: Greg KH <greg@kroah.com>
Subject: Re: [RFC] put symbolic links between drivers and modules in the sysfs tree
Date: Sat, 25 Sep 2004 09:46:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040925164621.GA9098@kroah.com>
References: <1095701390.2016.34.camel@mulgrave> <20040925073819.GT23987@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:36552 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S269217AbUIYQsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 12:48:10 -0400
Content-Disposition: inline
In-Reply-To: <20040925073819.GT23987@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Sep 25, 2004 at 08:38:19AM +0100, viro@parcelfarce.linux.theplanet.co.uk wrote:
> On Mon, Sep 20, 2004 at 01:29:44PM -0400, James Bottomley wrote:
> > This functionality is essential for us to work out which drivers are
> > supplied by which modules.  We use this in turn to work out which
> > modules are necessary to find the root device (and hence what
> > initrd/initramfs needs to insert).
> 
> So what will your userland code do when you run it on a system with
> non-modular kernel currently running?
> 
> IOW, that's a fundamentally broken interface - you really want the same
> information regardless of modular vs. built-in.

I agree, and Rusty has some pending patches that provide that
information for all drivers built into the system.  When they are
merged, this symlink will be created for those also (with a bit of
tweaking, but it will happen.)

thanks,

greg k-h
