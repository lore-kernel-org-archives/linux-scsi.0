From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: SG_IO ioctl (was: mode sense blacklist how)
Date: 28 Nov 2003 10:09:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070039368.2319.76.camel@patrh9>
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
Received: from email-out1.iomega.com ([147.178.1.82]:28397 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262738AbTK1RJ7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 12:09:59 -0500
In-Reply-To: <1069447873.14422.229.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> > Does "not interruptible" mean
> > timeouts don't work, or ...
> > only timeouts work, or ...
> > only timeouts and resets but not SIGINT ...
>
> From: http://marc.theaimsgroup.com/?l=linux-scsi&m=106937826522932
> Date: 2003-11-21 1:17:16 ...
>
> "not interruptible" in this context means ...
> The SCSI command timeout should bring things
> back but often at the expense ...

I hear you say: timeouts do cancel ioctl SG_IO but only by way of an
automagic reset of the target device that may disrupt contemporaneous
talk with other devices nearby.

I guess asynchronous reset by a parallel thread not yet mentioned
because that service does not yet exist.

Right?

In 2.6.0-test10 we have no way for another thread of the process trying
ioctl SG_IO to ask to cancel the ioctl of the first thread?

ioctl SG_IO runs to completion or to timeout or to reboot always?

> signals (e.g. control-C from the keyboard or
> kill-9) have no effect while waiting for the
> SCSI response.

I hear you say: SIGINT does not cancel ioctl SG_IO.

> The SCSI command timeout should bring things
> back but often at the expense ... can have
> some nasty side effects (e.g. if your root
> file system is on a disk on the same SPI bus).

Aye.

Pat LaVarre


