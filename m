From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Thu, 16 Jun 2011 08:41:29 -0700
Message-ID: <20110616154129.GA31498@kroah.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47585 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab1FPPl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 11:41:57 -0400
Content-Disposition: inline
In-Reply-To: <4DF9F11F.705@hitachi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Thu, Jun 16, 2011 at 09:03:43PM +0900, Nao Nishijima wrote:
> Hi Greg,
> 
> (2011/06/16 0:33), Greg KH wrote:
> > On Wed, Jun 15, 2011 at 05:16:28PM +0900, Nao Nishijima wrote:
> >> Allow users to set the preferred name of device via sysfs interface.
> >>
> >> (Exsample) sda -> foo
> >> # echo foo > /sys/block/sda/preferred_name
> >>
> >> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >> Suggested-by: Jon Masters <jcm@redhat.com>
> >> Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
> > 
> > You don't document this new sysfs file (which is required), nor do you
> > explain what it is for and how to use it.
> > 
> > Please do that in this patch, and in a Documentation/ABI/ file for any
> > new sysfs file you create.
> >
> 
> I'm afraid that my explanation was not enough.
> I will add explanation to this patch and Documentation/ABI file.
> 
> > I still fail to understand how a "preferred" file will help anyone out
> > here at all...
> >
> 
> Let me explain, users cannot identify a device from a device name
> because device names may change at each boot up time. If kernel show
> preferred names in kernel messages, users can easily identify a device
> from kernel messages.

I understand your request for the kernel to print out these types of
names, but I'm still not sold on this being an issue that is the
kernel's to deal with at all.

Again, how would you handle multiple persistant names for the same
device being used at the same time?

And again, why not just fix the userspace tools?  That is trivial to do
so and again, could have been done by now in the years this has been
discussed.

thanks,

greg k-h
