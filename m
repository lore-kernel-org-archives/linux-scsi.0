From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: SG_IO ioctl (was: mode sense blacklist how)
Date: 28 Nov 2003 10:07:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070039244.2319.73.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
	 <1068777510.2851.359.camel@patrh9>
	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>
	 <1068838908.2852.34.camel@patrh9>
	 <1069246502.3fbb6826955dd@webmail.netregistry.net>
	 <1069261377.2867.37.camel@patrh9>  <3FBBFDFB.9010406@torque.net>
	 <1069345927.6663.27.camel@patrh9>  <3FBD679C.5010405@torque.net>
	 <1069447873.14422.229.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:10674 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262695AbTK1RHy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 12:07:54 -0500
In-Reply-To: <1069447873.14422.229.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> From: http://marc.theaimsgroup.com/?l=linux-scsi&m=106937826522932
> Date: 2003-11-21 1:17:16
>
> "Linux Kernel Development" Robert Love
> ISBN 0-672-32512-8 covers lk 2.6 pretty well
> including these issues. [Note in passing: the
> book makes no mention of the SCSI or ATA
> subsystems or aio:-(]

Thanks for the link, will pursue.

So far in hardcopy I have read only the obsolete lk 2.0 Linux Kernel
Internals M. Beck et al.

http://www.amazon.com/exec/obidos/ASIN/0201331438

>From my first reading I gathered Two facts that I then mentioned in
linux-fsdevel.  1) Kconfig files contain much of the `make xconfig`
text.  2) `gdb /usr/src/linux/vmlinux /proc/kcore` may start working for
me if I try CONFIG_DEBUG_KERNEL=y, CONFIG_DEBUG_INFO=y.

At amazon, that obsolete lk 2.0 second edition links to an lk 2.4.4
retitled third edition, "Linux Kernel Programming", also to the lk 2.6
US$31.49 "Linux Kernel Development" you mention:

http://www.amazon.com/exec/obidos/ASIN/0672325128

Pat LaVarre


