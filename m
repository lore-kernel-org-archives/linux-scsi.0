From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/3][-mm] reclassify the sg_sysfs_class mutex
Date: Tue, 20 May 2008 21:37:20 -0700
Message-ID: <20080521043720.GB8950@kroah.com>
References: <20080520095851.GB3201@darkstar.te-china.tietoenator.com> <20080520172259.GB11666@kroah.com> <a8e1da0805201825w4c8e35d7o55db8af9e04981df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46859 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYEUEjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2008 00:39:44 -0400
Content-Disposition: inline
In-Reply-To: <a8e1da0805201825w4c8e35d7o55db8af9e04981df@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, matthew@wil.cx, kay.sievers@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 09:25:58AM +0800, Dave Young wrote:
> On Wed, May 21, 2008 at 1:22 AM, Greg KH <greg@kroah.com> wrote:
> > On Tue, May 20, 2008 at 05:58:51PM +0800, Dave Young wrote:
> >> [Please first apply the patch 1/3 before this]
> >>
> >> To please lockdep here we use class_reclassify to change
> >> the lock class of sg_sysfs_class
> >
> > Are you suggesting we do this for every struct class in the kernel?  If
> > so, why not just do it in the class core, instead of having to modify
> > every single caller?
> 
> I don't think it necessary to do this for every class, because only
> class_interface_* calls could cause the issue, and the
> class_interface_* are only used by pcmcia & scsi, do you think there
> will be other users of them?

I do not know, there might be in the future.

thanks,

greg k-h
