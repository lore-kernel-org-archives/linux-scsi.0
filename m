From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7130] New: loading driver eat all CPU and
 since some time may block all system disk IO (even can not reboot)
Date: Sat, 9 Sep 2006 08:36:31 -0700
Message-ID: <20060909083631.95a63528.akpm@osdl.org>
References: <200609091032.k89AW7bM017561@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61899 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932272AbWIIPg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Sep 2006 11:36:59 -0400
In-Reply-To: <200609091032.k89AW7bM017561@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, wizard580@gmail.com, sparclinux@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Sat, 9 Sep 2006 03:32:07 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7130
> 
>            Summary: loading driver eat all CPU and since some time may block
>                     all system disk IO (even can not reboot)
>     Kernel Version: 2.6.17.12
>             Status: NEW
>           Severity: blocking
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: wizard580@gmail.com
> 
> 
> Most recent kernel where this bug did not occur: 2.6.17.12
> Distribution: Debian SID/Unstable
> Hardware Environment: SUN UltraSparc2 E3500 FC-AL SCSI hard drives
> Software Environment: Debian with latest updates on 09.09.2006
> Problem Description: When I load a driver fcal, mu cpu will be 100% busy and 
> will never fred. modprobe fcal will never ends. If I do not restart 
> immediately, then since 2-4min I can not even reboot. Seems to there is a 
> block of all disk io. A top and so programs running fine, until exit. Start 
> again will fail.
> So... may be because of that, I can not see my FC-AL scsi hard drives.
> My hardware (if I did't mistaken):
> 1) X2652A FC-AL INTERFACE BOARD 3500.
> 2) X6731A FCAL GBIC MODULE 100MB/SEC
> P.S.: I do anything for seeing my hard drives in Debian. If I need to tell you 
> any info, or make a tests, just let me know. :)
> If anybody can quickly help, I will be blessed. :D My life is bet on this.
> P.P.S:
> hard drives I see in "pre boot 'bios' with probe-fcal-all command"
> 
> Steps to reproduce:
> modprobe fcal on a Sparc arch.
> 

Does anyone else us the fcal driver?

I'd suggest the next step would be to run a kernel profile, or just sysrq-P
to find out where the CPU is stuck.  Could a sparc person please talk the
reporter through that process?

Thanks.

