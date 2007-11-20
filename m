From: Jonathan McDowell <noodles@earth.li>
Subject: Re: [PATCH] Unify sysfs filenames for firmware version
Date: Tue, 20 Nov 2007 09:14:55 -0800
Message-ID: <20071120171454.GH31112@earth.li>
References: <20071120133824.GD31112@earth.li> <47430CCE.50701@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from the.earth.li ([193.201.200.66]:42147 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbXKTRO5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 12:14:57 -0500
Content-Disposition: inline
In-Reply-To: <47430CCE.50701@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Matt_Domsch@dell.com

On Tue, Nov 20, 2007 at 11:35:26AM -0500, James Smart wrote:
> The hearburn I have with these patches is that you are changing
> driver-specific attributes, not common ones as enforced/requested by a
> subsystem. As such, you are breaking a management interface for
> existing tools/scripts.

Yes, that's true. Though at present we have the heartburn that anyone
wanting to write a script to pull out firmware revisions has to know
exactly where every driver stores this information.

> There's been a long-standing request to create common device
> attributes, such as fw_version, but I don't think they ever made it
> into the kernel. Not only would the names be consistent, but the
> location would be consistent as well.
> 
> I'd rather you took on that work, than proceed with these patches.

Do you have a pointer to previous discussion about this? A central
device attribute does make more sense. It'd be nice to have uniform
access to details like the driver version as well.
 
> Jonathan McDowell wrote:
> >Looking around sysfs in an attempt to pull out SCSI card firmware
> >versions I found 5 different filenames used to store the information.
> >Only one, fw_version, was used more than once. The patch below changes
> >the other drivers to use this filename too.
> >
> >I suspect the same applies to other subsystem drivers as well. I'll look
> >at them assuming this patch is well received.

J.

-- 
You have a tendency to feel you are superior to most computers.
This .sig brought to you by the letter U and the number 25
Product of the Republic of HuggieTag
