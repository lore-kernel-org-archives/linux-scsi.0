From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Removing BROKEN scsi drivers
Date: Thu, 06 Oct 2005 08:36:27 +1000
Message-ID: <4344556B.3030700@torque.net>
References: <200510051314.33411.ak@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:40847 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1030404AbVJEWf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2005 18:35:56 -0400
In-Reply-To: <200510051314.33411.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org

Andi Kleen wrote:
> In 2.6.14rc3:
> 
> linux/drivers/scsi> grep -c BROKEN Kconfig
> 11
> 
> There are a lot of SCSI drivers who have been marked BROKEN forever. Or at 
> least for all of 2.6 and one would expect if there are users left they would 
> have fixed them by now. Would it make sense to remove them?
> 
> In particular:
> 
> SCSI_ADVANSYS - vendor went out of market afaik. Probably not many left.

Andi,
My advansys controllers work fine in lk 2.6 .
Advansys itself (or its SCSI HBA line) was onsold
several times. I'm not sure if they are still
available (the last ones for sale that I noticed
were for SCSI (SPI-based) scanners). When lk 2.5
development changes broke the drivers, patches came
in from several contributors to fix them (usually
the minimum required). I believe they are still
out there, probably in decreasing numbers (e.g.
I decommissioned a server using one last week).
It's nice (albeit aging) hardware whose reliability
exceeds that of a few other HBA manufacturers'
products I could name.

So whoever marked the advansys driver as broken
was making some political statement IMO. If it
ain't broken, it shouldn't be marked as BROKEN.


If the kernel source was split up at some stage (rather
than one big source tarball), it may be appropriate
to put the advansys driver in with the second tier
(looking for a better term than "legacy") drivers.

Doug Gilbert


