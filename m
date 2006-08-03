From: "Scott Lowrey" <slowrey@nextone.com>
Subject: RE: Performance Problem with LSI Logic 53c1030 RAID
Date: Thu, 3 Aug 2006 14:37:13 -0400
Message-ID: <8812D8156467224C9E9739E513037EF1013028C7@moe.nextone.local>
References: <664A4EBB07F29743873A87CF62C26D7026B967@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.nextone.com ([209.125.86.104]:37859 "EHLO
	mail1.nextone.com") by vger.kernel.org with ESMTP id S1030187AbWHCShP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Aug 2006 14:37:15 -0400
Content-class: urn:content-classes:message
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7026B967@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org

> From: Moore, Eric [mailto:Eric.Moore@lsil.com]
> Sent: Thursday, August 03, 2006 2:07 PM
> To: Scott Lowrey; linux-scsi@vger.kernel.org
> Subject: RE: Performance Problem with LSI Logic 53c1030 RAID
> 
> -- On Thursday, August 03, 2006 11:50 AM, Scott Lowrey wrote:
> >
> > Problem:
> >       Deteriorating disk write performance with large files.
> >
> >       The problem *disappears* completely if RAID is disabled
> > or if the
> > array
> >       is put into a degraded state by pulling the secondary
> > array drive.
> > The
> >       problem *remains* if the primary array drive is pulled.
> >
> 
> 
> Is it possible for you to upgrade to the latest stable kernel on
> www.kernel.org, such as 2.6.17, or even 2.6.18-rc3.  This issue would
> be solved.  I believe one of your disks in your integrated volume
> is running asyn narrow, due to a bug in the driver.  From 2.6.17
kernel,
> the mptspi driver is using the spi transport layer.
> 

I'm confused.  Are you saying the driver has a bug?  If so, we're using
the latest MPT drivers from LSI -- 3.02.68.

Or are you saying that the newer kernel interacts with the driver in a
different way?

We could update the kernel, but time is a factor and we'd have to do a
lot of testing before release.... hmm... probably worth doing a quick
build-and-test to see if it works.
