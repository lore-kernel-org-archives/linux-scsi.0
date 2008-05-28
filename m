From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH][-mm] reclassify sg_sysfs_class for lockdep
Date: Wed, 28 May 2008 08:49:43 -0600
Message-ID: <20080528144943.GI22636@parisc-linux.org>
References: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58481 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYE1Otp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2008 10:49:45 -0400
Content-Disposition: inline
In-Reply-To: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 27, 2008 at 06:10:09PM +0800, Dave Young wrote:
> As register sg_interface, the sg_add will be called, which then will
> add device to sg_sysfs_class. This will cause lockdep warning,
> please see following email
> 
> In this case the locks are from diffrent classi, one is sdev_class,
> another is sg_sysfs_class 
> 
> Here reclassify the sg_sysfs_class for lockdep

Look, you've been told how to do this properly.  Send me the patch that
does the mutex conversion and I'll do a patch on top of that.  I have no
inclination to go wading in the cesspool of patches that is mm trying to
find yours.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
