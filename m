From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: SCSI vs SATA considerations
Date: Sat, 08 May 2004 20:52:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409D2C56.7B7BEE7E@danbbs.dk>
References: <200405071455.i47EtBB18653@www.watkins-home.com>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepc.post.tele.dk ([195.41.46.237]:2588 "EHLO
	pfepc.post.tele.dk") by vger.kernel.org with ESMTP id S264072AbUEHStd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 May 2004 14:49:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: Linux-scsi <linux-scsi@vger.kernel.org>

Guy wrote:
> 
> Check the jumpers on the disk.  Most have a force SE jumper, that would
> limit you to 40M/s.
> Also, anything else on the SCSI bus?  If so, if 1 device is SE the bus
> must be SE, which would limit you to 40M/s.

No other devices on the scsi bus.
The SE jumper is not installed. Tried with/without - once had an older
IBM scsi disk where the docs had the definition on one pin reverted :-
I had it jumpered as ID2; making it ID0, for some reason it properly
negotiates as a 160 device, at 80MHz, of cause.
I still get only 34.4 MB/s, though (misspelled the speed in first post).
Tried forcing 80MB/s, disabling domain validation, and forcing
termination on the 29160, no change.

Been thinking if IBM at some point sold some DDYS's as pure UW 40MB/s
disks, to satisfy the market...

Out of ideas, except flashing the controller. Latest BIOS should do some
BIOS optimizations and device order stuff, whatever that means.


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mogens Valentin
> Sent: Friday, May 07, 2004 7:57 AM
> To: Linux-scsi
> Subject: SCSI vs SATA considerations
> 
> On a new DDR400, 2200MHz cpu, system, using 29160 with an IBM DDYS disk,
> I get 37MB/s. For reasons I don't understand, the DDYS won't negotiate
> at 80MB/s, will only do 40MB/s.

-- 
Kind regards,
Mogens Valentin
Networking, Security
www.danbbs.dk/~monz
Phone +45 32 525 878
