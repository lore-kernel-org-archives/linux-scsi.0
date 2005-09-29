From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 12:54:57 -0400
Message-ID: <433C1C61.30506@pobox.com>
References: <Pine.LNX.4.10.10509281227570.19896-100000@master.linux-ide.org> <433B0374.4090100@adaptec.com> <20050928223542.GA12559@alpha.home.local> <433BFB1F.2020808@adaptec.com> <433BFEDB.6050505@pobox.com> <433C0D30.9050901@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:41196 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932245AbVI2QzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 12:55:05 -0400
In-Reply-To: <433C0D30.9050901@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andre Hedrick <andre@linux-ide.org>, Patrick Mansfield <patmans@us.ibm.com>, Luben Tuikov <ltuikov@yahoo.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Luben Tuikov wrote:
> of SAS.  THE REASON THEY WERE INTRODUCED INTO LINUX BY JB IS TO
> ACCOMODATE MPT-based SOLUTIONS FROM TWIDDLING WITH IOCTLS!

Wrong.  This shows you fundamentally don't understand transport classes 
at all.

AFAIK, the first transport class was FC, for qla2xxx.

Read the code to see how FC avoids the SPI-centric scan -- an example of 
transport independence.


> How do I know this: simple: JB's "transport attributes" have
> NOTHING to do with SAM.
> 
> They break the layering architecture for one, and are
> ATTRIBUTE EXPORTING FACILITY for another.

Transport class == transport layer.  Eventually this will sink in.

Transport class allows for complete transport independence, be it SAS, 
FC, iSCSI, or other.


> And as you can see, Linux today is the most anal retentive as it
> has ever been (e.g. SAS, reiser4, and other (revolutionary) technologies).
> 
> Remember, you can only go _down_ from the top.  So please
> do not say
>    "Linux is the most successful it's ever been."

We've still got all that Microsoft and old-Unix marketshare to steal :)


> It's too immature as it means that it would either go down
> or that it cannot become even _more_ successful.
> 
> 
>>The rest of the Linux-SCSI devs are trying to make it less SPI-centric. 
>>  Rather than just complain, we're doing something about it.
> 
> 
> Oh this is such a political sap, Jeff -- I cannot believe
> you're actually saying this.

I'm merely stating I'm submitting patches to clean up SCSI core.  Others 
have submitted far more patches than I.  And further patches to SCSI 
core are needed to properly integrate SAS as a transport completely 
independent from SPI.  I'm going to be putting time and effort into 
moving the SCSI core away from SPI, so that SAS can be properly integrated.

All I've seen from you is
(a) complaints that the SCSI core is too SPI-centric
(b) a solution that does nothing to fix this


> Who are you pleasing?  Your management?

My goal is Linux.  Always has been.  I put quality of Linux code, and 
giving features to Linux users, above all else.  Have been doing so 
regardless of who employs me, for many years now.

Maybe one day I will be independently wealthy, be a completely 
independent Linux maintainer, and then people will have to find 
something other than Red Hat as the reason for why their code is 
receiving criticism.


> I doubt you've ever been honest with me.*  The reason is that
> you are trying to push down my throat JB's "transport classes",
> all the while you're saying I'm supposed to change other people's
> code?

To get a fully SPI-independent SCSI core, we must change other people's 
code.  That's the way Linux works.  We evolve the existing code.

	Jeff


