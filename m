From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
Date: Fri, 3 Sep 2004 15:57:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040903205751.GA26691@lists.us.dell.com>
References: <20040903204400.26701.76199.Mailman@linux.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:56792 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S269763AbUICU6H
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2004 16:58:07 -0400
Content-Disposition: inline
In-Reply-To: <20040903204400.26701.76199.Mailman@linux.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>

> From: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
> Date: Fri, 3 Sep 2004 14:13:49 -0600
> 
> On Friday 03 September 2004 12:09 pm, Patrick Mansfield wrote:
> > > Thanks, I knew there must be a cool way.  That doesn't help if you're
> > > trying to figure out the correct "root=" to boot your box, of course...
> > 
> > What exactly is the "root=" problem? You mean device names changing?
> 
> Walk up to a box with a number of data disks already attached.  Plug
> in a new disk with a root filesystem on it.  Now try to boot the box,
> using the new root filesystem.  What do you specify?  It's difficult
> in general to figure it out.  

This is just another manifestation of the fact that there is no
connection between what system BIOS knows of as disks, and what the
kernel knows of as disks.

EDD 3.0 is supposed to help solve this.  Pity so few BIOS
manufactureres implement it, and of those that do, implement it
properly.  http://linux.dell.com/edd/

On EFI systems, there are some EFI Variables exported, BlkXXXXXX which
contain the EDD 3.0 / EFI device path information, probably even with
the partition table GUIDs - it's been too long since I've had a look.
But if so, you could use those to correlate to a Linux device name.

Or, of course, initrd and file system labels work great most of the
time.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
