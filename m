From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Thu, 16 Jun 2011 22:25:23 -0700
Message-ID: <20110617052523.GB741@kroah.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com>
 <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave>
 <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave>
 <20110616181943.GB1439@kroah.com>
 <1308256290.2436.143.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39641 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756576Ab1FQF0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2011 01:26:46 -0400
Content-Disposition: inline
In-Reply-To: <1308256290.2436.143.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Thu, Jun 16, 2011 at 04:31:29PM -0400, James Bottomley wrote:
> > So again, I really don't like this, just fix the userspace tools to map
> > the proper device name that the kernel is using to the userspace name
> > the tool used, and all is fine.  This has been done already today,
> > succesfully, by many of the big "enterprise" monitoring systems that
> > work quite well on Linux, proving that this is not something that the
> > kernel needs to provide to implement properly.
> 
> Well, it's expediency.  Sure we could try to patch the world, but I
> think the simple patch of getting the kernel to print a preferred name
> solves 90% of the problem.  Sure there is a long tail of userspace
> components that needs fixing, but that can be done gradually if we take
> the kernel route.  If we go the userspace route, it will be a long while
> before we even get to 50% coverage.

I do not think that just because some people feel it is easier to change
the kernel than change userspace tools, that we are somehow forced to
accept their changes.

As for "expediency", it has been a full year since the last time this
was proposed.  All userspace tools that would need to be changed to
implement this in userspace have had updates released for them in that
year, and the changes needed to make to them could have been done
already.

So any argument about "quickness" here which requires a kernel change
instead of fixing userspace programs is totally false, sorry.

greg k-h
