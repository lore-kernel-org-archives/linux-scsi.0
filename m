From: Pavel Machek <pavel@ucw.cz>
Subject: Re: sequential I/O on SSD disk varies from 20 to 300 MBytes/s every
 week
Date: Wed, 25 Feb 2015 22:50:07 +0100
Message-ID: <20150225215006.GC29527@amd>
References: <alpine.DEB.2.00.1502021427020.2997@q.xf.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48910 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbbBYVuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 16:50:11 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1502021427020.2997@q.xf.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Siim Vahtre <siim@xf.ee>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi!

> During the testing period of about 5 months I have concluded:
> 
> 1) There are 3 identical Fujitsu RX200 S6 test servers which all show the
> same problem, but I also reproduced it on some Sun Fire and Dell server.
> 
> 2) The problem happens with both HW RAID (MegaRAID SAS 2108) and when disks
> were directly on integrated SATA card.
> 
> 3) The problem happens with different Kernel versions (tried 3.14, 3.16,
> 3.18)
> 
> 4) The problem happens with newest FW/BIOS versions and on older version
> 
> 5) I have checked/replaced the cabling.
> 
> 6) It is not a caching issue (controller/disk caches were off during
> testing, but even putting them on had minor impact on the results)
> 
> 7) The problem happens with both 2.5" SATA (12 x HGST Travelstar 1TB, 3 x WD
> Black 750G), and SSD disks (3 x Samsung Pro 840)
> 
> 8) I have NOT been able to reproduce it on Windows - the speeds have been
> good for all disks at all times.
> 
> 9) Changing the disks (eg. taking currently slow disk and putting it to
> another server) has mixed results - it usually triggers some change of speed
> (slow becomes fast or vice-versa) but not always.
> 
> 
> The only thing that somewhat correlates with the change of speed is the
> environment: the IO speed of disks is generally better when testing in the
> office vs if that exact same server is in the server room. It might just
> been luck, however.

> I did not find correlation with the uptime, restarts, change of temperature,
> etc, so I assumed it might be the vibrations/rotations for SATA disks, but
> now that I have reproduced it with expensive SSD disks as well, I am out of
> ideas.


That's strange. Vibrations? But not for SSDs. Does hwmon say anything
interesting? Anything in smart?

> Only 20Mbytes/s on SSD must be wrong, right? (Especially if week earlier or
> week later it is ~300MBytes/s).

Yes.

Can you try the disks in different mainboard (but keep software
version?)

Are there any other performance problems?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
