From: Shane Wegner <shane@cm.nu>
Subject: Performance with multiple drives
Date: Sun, 18 Apr 2004 13:34:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418203408.GA16788@cm.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from continuum.cm.nu ([216.113.193.225]:15328 "EHLO continuum.cm.nu")
	by vger.kernel.org with ESMTP id S264102AbUDRUeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 16:34:10 -0400
Received: from shane by continuum.cm.nu with local (Exim 4.31)
	id 1BFIzR-0004Rd-Aw
	for linux-scsi@vger.kernel.org; Sun, 18 Apr 2004 13:34:09 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello list,

I am experiencing a performance hit on my SCSI setup here
and am wondering if this is to be expected or whether there
is anything I can do about it.  In summary, when reading
from a single drive, I am getting read performance of
approx 73mb/s, when reading from two drives concurrently,
regardless of which two, reads drop to 64mb/sec per drive
and when reading from all three, read performance is
approximately 46mb/sec.  The drives are matched Maxtor
Atlas 10K IV sca units using a dual channel u160 onboard
aic7xxx controler.  Two drives are on channel 0 and the
third is on channel 1.  The drives are sca units so I had
to use 80/68 pin converters on all three in case that would
make a difference as I couldn't find a scsi backplane which
would support splitting the drives across the channels as
is necessary due to the 160mb/sec channel limit.

The system is a dual Pentium III tualatin setup with 1gb of
ram.  The board claims to support 64 bit 66mhz pci on the
scsi bus and I have no legacy cards on that particular bus
so it should be running at 64 bit.  However, I don't know
of a way to verify that under linux.

If anyone has any suggestions on how I can find the
bottleneck, I would appreciate it.

Best,
Shane

-- 
Shane Wegner
http://www.cm.nu/~shane/
