From: Willem Riede <wrlk@riede.org>
Subject: Re: SG_IO ioctl (was: mode sense blacklist how)
Date: Thu, 20 Nov 2003 22:18:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121031805.GH5672@linnie.riede.org>
References: <1068775834.2851.321.camel@patrh9> <20031113181945.I30194@one-eyed-alien.net> <1068777510.2851.359.camel@patrh9> <1068779468.3fb447ccc6e60@webmail.netregistry.net> <1068838908.2852.34.camel@patrh9> <1069246502.3fbb6826955dd@webmail.netregistry.net> <1069261377.2867.37.camel@patrh9> <3FBBFDFB.9010406@torque.net> <1069345927.6663.27.camel@patrh9> <3FBD679C.5010405@torque.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:52628 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S264241AbTKUDSH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 22:18:07 -0500
Content-Disposition: inline
In-Reply-To: <3FBD679C.5010405@torque.net> (from dougg@torque.net on Thu, Nov 20, 2003 at 20:17:16 -0500)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.11.20 20:17, Douglas Gilbert wrote:
> 
> ** The sd/sr/st <-> sg mapping problem would be much simpler
> in lk 2.6 if sg (plus st + osst) had sysfs visibility. Perhaps
> udev could work out this mapping but this would still rely
> on polling through sg, st and osst file descriptors with the
> attendant problems that brings (e.g. blocking, O_EXCL, O(n)).

If I'm not mistaken, Kai posted an initial patch to add sysfs
support to st. If that works, and this mapping is important,
I'll be happy to do the same for osst.

Regards, Willem Riede.
