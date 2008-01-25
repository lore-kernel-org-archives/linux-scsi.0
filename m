From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: sd incorrectly reports write cache disabled on cache-capable
	drives/controllers
Date: Fri, 25 Jan 2008 15:33:21 -0600
Message-ID: <1201296801.3119.63.camel@localhost.localdomain>
References: <200801252159.20858.yallaone@gmail.com>
	 <1201295720.3119.51.camel@localhost.localdomain>
	 <200801252228.22659.yallaone@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46255 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469AbYAYVd1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 16:33:27 -0500
In-Reply-To: <200801252228.22659.yallaone@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Halim Issa <yallaone@gmail.com>
Cc: linux-scsi@vger.kernel.org


On Fri, 2008-01-25 at 22:28 +0100, Halim Issa wrote:
> Thank you so much for the quick reply - I risk asking one follow-up question.
> 
> On Friday 25 January 2008 22:15:20 James Bottomley wrote:
> > The "cache" hear would be referring to the RAID controller cache, not
> > the disk cache.  Likewise DPO and FUA refer to what the RAID controller
> > can support, not the disk.
> 
> Would it be safe to assume that the problem thus lies within the mptfusion 
> driver, since a) the LSI Logic controller in question does indeed have 
> hardware cache capabilities; and b) an older kernel version as well as 
> Windows Server, correctly loads with the correct cache parameters at boot?

I don't think it would be correct to assume that there actually is a
problem.  Most RAID controllers habitually lie about having a cache in
their INQUIRY strings because they don't want to deal with the kernel
sending SYNCHRONIZE_CACHE commands down.

Just because the inquiry strings say it doesn't have a cache doesn't
really mean it's not using one but not telling anyone.

James


