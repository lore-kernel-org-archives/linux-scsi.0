From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI vs SATA considerations
Date: Sun, 09 May 2004 12:25:37 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409D96A1.7000500@torque.net>
References: <200405071455.i47EtBB18653@www.watkins-home.com> <409D2C56.7B7BEE7E@danbbs.dk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:24849 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264262AbUEIC2H
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 May 2004 22:28:07 -0400
In-Reply-To: <409D2C56.7B7BEE7E@danbbs.dk>
List-Id: linux-scsi@vger.kernel.org
To: monz@danbbs.dk
Cc: Guy <bugzilla@watkins-home.com>, Linux-scsi <linux-scsi@vger.kernel.org>

Mogens Valentin wrote:
> Guy wrote:
> 
>>Check the jumpers on the disk.  Most have a force SE jumper, that would
>>limit you to 40M/s.
>>Also, anything else on the SCSI bus?  If so, if 1 device is SE the bus
>>must be SE, which would limit you to 40M/s.
> 
> 
> No other devices on the scsi bus.
> The SE jumper is not installed. Tried with/without - once had an older
> IBM scsi disk where the docs had the definition on one pin reverted :-
> I had it jumpered as ID2; making it ID0, for some reason it properly
> negotiates as a 160 device, at 80MHz, of cause.
> I still get only 34.4 MB/s, though (misspelled the speed in first post).
> Tried forcing 80MB/s, disabling domain validation, and forcing
> termination on the 29160, no change.
> 
> Been thinking if IBM at some point sold some DDYS's as pure UW 40MB/s
> disks, to satisfy the market...
> 
> Out of ideas, except flashing the controller. Latest BIOS should do some
> BIOS optimizations and device order stuff, whatever that means.

Mogens,
Perhaps you could try sg_rbuf in the sg3_utils package (see
http://www.torque.net/sg ). sg_rbuf uses the READ BUFFER
SCSI command and on most disks (e.g. recent seagate and
fujitsu) sources data out of the disk cache quickly. The best
figure that I have seen is about 110 MB/sec on a U160 bus when
the streaming performance of the disk was about half that figure.

IBM transferred their disk business to Hitachi (joint venture?)
a few years back.

BTW recent press releases from maxtor and fujitsu claim 100
MB/sec streaming performance on the U320 bus for
(soon to be released) 15k rpm disks.

Doug Gilbert

