From: Matthew Wilcox <willy@debian.org>
Subject: Re: advansys driver vs 2.6 breakage
Date: Thu, 7 Aug 2003 20:56:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807195656.GJ22222@parcelfarce.linux.theplanet.co.uk>
References: <200308070422.41412.gene.heskett@verizon.net> <20030807112157.GF22222@parcelfarce.linux.theplanet.co.uk> <200308071444.55616.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49616 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270498AbTHGT45
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 15:56:57 -0400
Content-Disposition: inline
In-Reply-To: <200308071444.55616.gene.heskett@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

On Thu, Aug 07, 2003 at 02:44:55PM -0400, Gene Heskett wrote:
> 1. For whatever reason, the diffs between the 2.4.22-pre10 version of 
> this driver and the 2.6.0-test2-mm2 versions are extensive, many 
> kilobytes.  Done by who knows, and basicly 
> un-commented/un-documented.

Irrelevant to whether or not check_region is broken.

> 2. Substituting the request_region call, with no other changes, made 
> it work.
> 
> 3. Adding the release_region calls broke it again, even worse than 
> before.

I don't see how adding release_region can make it "worse than before".
Look at what __check_region does in kernel/resource.c.

> >Something else is going on here, and someone with one of these cards
> >needs to debug it properly.
> 
> I agree.  Its a very good scsi-2 fast (20Mb/sec) card, something thats 
> impossible to find new today.

So you're willing to help debug this properly?  OK.  I'd like you to
turn on ADVANSYS_DEBUG (around line 828 of the driver).  Then send me
the debug messages the driver emits during bootup.

For comparison, I'd also like to see them from 2.4.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
