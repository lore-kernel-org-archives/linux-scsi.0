From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Thu, 7 Aug 2003 14:44:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308071444.55616.gene.heskett@verizon.net>
References: <200308070422.41412.gene.heskett@verizon.net> <20030807112157.GF22222@parcelfarce.linux.theplanet.co.uk>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out005pub.verizon.net ([206.46.170.143]:50100 "EHLO
	out005.verizon.net") by vger.kernel.org with ESMTP id S270484AbTHGSo6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 14:44:58 -0400
In-Reply-To: <20030807112157.GF22222@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: bfrey@turbolinux.com.cn, linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>

On Thursday 07 August 2003 07:21, Matthew Wilcox wrote:
>On Thu, Aug 07, 2003 at 04:22:41AM -0400, Gene Heskett wrote:
>> This is, FWIW, not the only code that is apparently broken by that
>> ioports.h header redefinition.
>>
>> I'm getting messages from other modules squawking about the
>> __deprecated status of "check_region" during the compile too.
>
>This seems to be a fundamental misunderstanding on your part.
>
>check_region is not broken.  It is deprecated.  That means we asked
> the compiler to emit a warning when someone tries to use it.  It
> does not mean that it will crash.
>
1. For whatever reason, the diffs between the 2.4.22-pre10 version of 
this driver and the 2.6.0-test2-mm2 versions are extensive, many 
kilobytes.  Done by who knows, and basicly 
un-commented/un-documented.

2. Substituting the request_region call, with no other changes, made 
it work.

3. Adding the release_region calls broke it again, even worse than 
before.

4.  The 2.4.x(x) version of this code, "3.3G" is extremely 
bulletproof.

>Something else is going on here, and someone with one of these cards
>needs to debug it properly.

I agree.  Its a very good scsi-2 fast (20Mb/sec) card, something thats 
impossible to find new today.

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

