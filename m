From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Performance Problem with LSI Logic 53c1030 RAID
Date: Thu, 3 Aug 2006 12:43:12 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7026B98E@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7815 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030193AbWHCSnP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Aug 2006 14:43:15 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Scott Lowrey <slowrey@nextone.com>, linux-scsi@vger.kernel.org

-- Thursday, August 03, 2006 12:37 PM, Scott Lowrey wrote:

> I'm confused.  Are you saying the driver has a bug?  If so, 
> we're using
> the latest MPT drivers from LSI -- 3.02.68.

I'm confused, I didn't know you pulled drivers from LSI website,
I thought you were using the built-n drivers in 2.6.11 kernel.
There was a bug in the upstream drivers back around that time
with new split drivers were introduced.  I can't remember
exactly which kernel it was, but it was around that time.

We have a tool called getspeed, I can send you to see what
speed your devices are negotiated at.  Let me know which arch
your running, and I will send in private email.

> 
> Or are you saying that the newer kernel interacts with the driver in a
> different way?

Yes, in 2.6.17 kernel, domain validation was moved our of mptspi,
and moved to generic layer in the spi transport.

> 
> We could update the kernel, but time is a factor and we'd have to do a
> lot of testing before release.... hmm... probably worth doing a quick
> build-and-test to see if it works.
> 

It would be nice to know whether your seeing it in the newer kernel or
not.

Eric

