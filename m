From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15950] Hang in dc395x driver
Date: Mon, 10 May 2010 05:14:37 GMT
Message-ID: <201005100514.o4A5Ebuh027931@demeter.kernel.org>
References: <bug-15950-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38627 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0EJFOi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2010 01:14:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4A5EbVV027932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 May 2010 05:14:37 GMT
In-Reply-To: <bug-15950-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15950





--- Comment #3 from ltskinol@gmail.com  2010-05-10 05:14:36 ---
On Sun, May 9, 2010 at 6:07 PM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=15950
>
>
>
>
>
> --- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-05-09 22:07:58 ---
> Reply-To: James.Bottomley@suse.de
>
> On Sun, 2010-05-09 at 21:19 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
>> I'm not sure when this problem started, but it's somewhere in the 2.6.2x
>> region.
>>
>> I'd be happy to recompile, test and debug if needed.
>
> Retesting isn't necessary.  There have only been nine changes to that
> driver in 2.6.2x.  The versions of interest (as in works/doesn't work)
> should be
>
> 2.6.26 (should be identical to 2.6.31, so just a something else changed
> sanity check)
> 2.6.25 (lots of pointless changes + sense buffer replacement)
> 2.6.34 (pid removal and sg chaining)
> 2.6.23 (accessors change)
> 2.6.22 (spelling only fix!)
>
> James
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You reported the bug.
>

I downloaded the .1 versions of kernel's 2.6.22 through 2.6.26, and
found that 2.6.25 and above had no changes in the dc395x.c file, but
that a variety of changes were introduced in 2.6.24 and below.  Since
the older dc395x.c doesn't drop into my current 2.6.31 kernel, I tried
recompiling and running 2.6.24 without success.  On Gentoo, the
current udev doesn't work with that older kernel, so things like
networking and X fail to run properly and I was unable to test the
scanner.  Suggestions?

Tom

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
