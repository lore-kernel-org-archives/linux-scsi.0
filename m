From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: [RFC] put symbolic links between drivers and modules in the sysfs tree
Date: Sat, 25 Sep 2004 08:38:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040925073819.GT23987@parcelfarce.linux.theplanet.co.uk>
References: <1095701390.2016.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:50152 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269082AbUIYHiV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 03:38:21 -0400
Content-Disposition: inline
In-Reply-To: <1095701390.2016.34.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: greg@kroah.com, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Sep 20, 2004 at 01:29:44PM -0400, James Bottomley wrote:
> This functionality is essential for us to work out which drivers are
> supplied by which modules.  We use this in turn to work out which
> modules are necessary to find the root device (and hence what
> initrd/initramfs needs to insert).

So what will your userland code do when you run it on a system with
non-modular kernel currently running?

IOW, that's a fundamentally broken interface - you really want the same
information regardless of modular vs. built-in.
