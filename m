From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Thu, 7 Aug 2003 17:36:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308071736.34538.gene.heskett@verizon.net>
References: <200308070422.41412.gene.heskett@verizon.net> <200308071444.55616.gene.heskett@verizon.net> <20030807195656.GJ22222@parcelfarce.linux.theplanet.co.uk>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out006pub.verizon.net ([206.46.170.106]:3790 "EHLO
	out006.verizon.net") by vger.kernel.org with ESMTP id S270630AbTHGVgh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 17:36:37 -0400
In-Reply-To: <20030807195656.GJ22222@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

On Thursday 07 August 2003 15:56, Matthew Wilcox wrote:
>On Thu, Aug 07, 2003 at 02:44:55PM -0400, Gene Heskett wrote:
>> 1. For whatever reason, the diffs between the 2.4.22-pre10 version
>> of this driver and the 2.6.0-test2-mm2 versions are extensive,
>> many kilobytes.  Done by who knows, and basicly
>> un-commented/un-documented.
>
>Irrelevant to whether or not check_region is broken.
>
>> 2. Substituting the request_region call, with no other changes,
>> made it work.
>>
>> 3. Adding the release_region calls broke it again, even worse than
>> before.
>
>I don't see how adding release_region can make it "worse than
> before". Look at what __check_region does in kernel/resource.c.
>
>> >Something else is going on here, and someone with one of these
>> > cards needs to debug it properly.
>>
>> I agree.  Its a very good scsi-2 fast (20Mb/sec) card, something
>> thats impossible to find new today.
>
>So you're willing to help debug this properly? 

Sure, it me with the hardware.

> OK.  I'd like you to
>turn on ADVANSYS_DEBUG (around line 828 of the driver).  Then send
> me the debug messages the driver emits during bootup.

Is it level (0,1,2 etc) sensitive?

>For comparison, I'd also like to see them from 2.4.

Well, I haven't built 2.4.22-rc1 yet, so I will, or would it be better 
if I went back to -pre8 and turned that one on?  I know it was stable 
here.

This will take about a day before I can get back with it, do you want 
it to the list, or just to you?  And would it be better if I made it 
as a module?, at least I'd have syslog running by the time it was 
init'ed.

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

