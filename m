From: "Scott Lowrey" <slowrey@nextone.com>
Subject: RE: Performance Problem with LSI Logic 53c1030 RAID
Date: Thu, 3 Aug 2006 17:19:30 -0400
Message-ID: <8812D8156467224C9E9739E513037EF101302A2D@moe.nextone.local>
References: <664A4EBB07F29743873A87CF62C26D7026B98E@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.nextone.com ([209.125.86.104]:53785 "EHLO
	mail1.nextone.com") by vger.kernel.org with ESMTP id S932289AbWHCVTc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Aug 2006 17:19:32 -0400
Content-class: urn:content-classes:message
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7026B98E@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org

> 
> > I'm confused.  Are you saying the driver has a bug?  If so,
> > we're using
> > the latest MPT drivers from LSI -- 3.02.68.
> 
> I'm confused, I didn't know you pulled drivers from LSI website,
> I thought you were using the built-n drivers in 2.6.11 kernel.

Notice that I posted the kernel mods in the Setup section - we 
updated the MPT drivers to the latest.  Strangely, we didn't see
this problem on our older 2.6.8 kernel... :-(

> 
> We have a tool called getspeed, I can send you to see what
> speed your devices are negotiated at.  Let me know which arch
> your running, and I will send in private email.

Excellent.  We're running i586.
 
> >
> > Or are you saying that the newer kernel interacts with the driver in
a
> > different way?
> 
> Yes, in 2.6.17 kernel, domain validation was moved our of mptspi,
> and moved to generic layer in the spi transport.
> 
> >
> > We could update the kernel, but time is a factor and we'd have to do
a
> > lot of testing before release.... hmm... probably worth doing a
quick
> > build-and-test to see if it works.
> >
> 
> It would be nice to know whether your seeing it in the newer kernel or
> not.

OK, I'll see if I can get that going.
