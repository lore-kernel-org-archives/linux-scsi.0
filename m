From: David Newall <davidn@davidnewall.com>
Subject: Re: Regression impacts ServeRAID II on IBM xSeries 5500
Date: Sat, 25 Jul 2009 00:59:05 +0930
Message-ID: <4A69D341.8030908@davidnewall.com>
References: <4A6172F0.60707@davidnewall.com> <20090723110118N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hawking.rebel.net.au ([203.20.69.83]:52583 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZGXP3J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2009 11:29:09 -0400
In-Reply-To: <20090723110118N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> Sorry for the delay,
>   

No problem. I appreciate your time.

> On Sat, 18 Jul 2009 16:30:00 +0930
> David Newall <davidn@davidnewall.com> wrote:
>   
>> According to "git bisect," your patch
>> 10db10d144c0248f285242f79daf6b9de6b00a62 is the first bad commit before
>> a regression which affects my ServeRAID II controller.  I get segfault
>> running ipssend, which is the program used to interrogate and configure
>> the SCSI RAID controller.
>>
>>     ipssend[5949]: segfault at 20202020 ip b7ece8b1 sp bfce1d1c error 6 in libc-2.9.so[b7e55000+15c000]
>>     
>
> Can I get 'ipssend' source code? I'm not sure what ipssend does (I
> guess, it issues some special commands via sg).
>   

It's provided by IBM with their ServeRAID CD, and not available in
source as far as I can discover. The RAID hardware uses Adaptec chips
and I think ipssend was written by them.


>> My machine and assistance is at your disposal.  Rather than guess what
>> information you want: what can I tell you?
>>     
>
> What kernel version do you use, the latest git tree?

I was running Ubuntu's 2.6.28-13-server, but have reverted to their
2.6.27-10-server, that being the latest Ubuntu-provided version on which
ipssend works. The patch which apparently introduced the regression is
for 2.6.27-rc9, which is quite old. The regression was a year ago, and
although I've found quite a few people who have the same problem, I
haven't found any indication of the problem having been previously
reported or bisected, so it's likely the latest version still has the
problem. I am happy to try the latest version of you want.
