From: Ricky Beam <jfbeam@bluetronic.net>
Subject: RE: qla2xxx (2100) vs. qlogicfc [again]
Date: Thu, 6 May 2004 16:40:56 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405061633340.14297-100000@sweetums.bluetronic.net>
References: <B179AE41C1147041AA1121F44614F0B060EE83@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:42224 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S262329AbUEFUp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2004 16:45:26 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EE83@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

On Thu, 6 May 2004, Andrew Vasquez wrote:
>>   ql2xdoinitscan=1

Actually, it sometimes is.  Otherwise, it will not (re)detect any disks,
of course, it's not seeing any disks, so the point is moot :-)

>> If the guys at Qlogic want to watch what I'm seeing, all they have
>> to do is ask.
>>
>
>SSH access?

I was thinking winders terminal server so you see the SAN gui's at the same
time (SANSurfer and Gadzoox's Ventana) plus the serial console.  But the
console is SSH reachable too.

>> PS: If someone wants to give me a QLA2300, I won't complain :-)
>>
>
>I'm tempted... try ebay:
>
>	http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&category=44994&item=3095100926&rd=1&ssPageName=WDVW
>
>20 bucks, 5days left to bid :p

Yeah, it's already on my watch list.  I'm guessing it'll go for much more
than that.

s/give/loan/ :-)

I can find Fusion MPT cards for ~50$, but that's adding one more wildcard
to the mess.

--Ricky

PS: completely OT but some developer needs to compile the old qla2100 and
    qla2200 drivers for xp-64 (amd64) :-) (The monkeys at intel need to
    buy an opteron and type make too.)


