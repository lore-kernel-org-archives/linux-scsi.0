From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] put symbolic links between drivers and modules in the
	sysfs tree
Date: 25 Sep 2004 09:14:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096118081.1715.3.camel@mulgrave>
References: <1095701390.2016.34.camel@mulgrave>
	<20040925073819.GT23987@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40926 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269322AbUIYNPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 09:15:12 -0400
In-Reply-To: <20040925073819.GT23987@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: greg@kroah.com, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-09-25 at 03:38, viro@parcelfarce.linux.theplanet.co.uk
wrote:
> On Mon, Sep 20, 2004 at 01:29:44PM -0400, James Bottomley wrote:
> > This functionality is essential for us to work out which drivers are
> > supplied by which modules.  We use this in turn to work out which
> > modules are necessary to find the root device (and hence what
> > initrd/initramfs needs to insert).
> 
> So what will your userland code do when you run it on a system with
> non-modular kernel currently running?

Not put a module in the initial ramdisk, since it would be unnecessary. 
The only information the patch seeks to add is the linkage between
driver and module.  So you can work back from sysfs to know which
devices have which modules

> IOW, that's a fundamentally broken interface - you really want the same
> information regardless of modular vs. built-in.

Not really.  It you argue this about module *parameters*, I might agree,
but not about what driver goes with what module...if the driver is build
in, then the answer is a simple "none" and the link doesn't exist.

James


