From: Alexy Khrabrov <braver@pobox.com>
Subject: A modern RAID solution?
Date: Sun, 27 Oct 2002 10:30:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027153048.GA5642@angle.setup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from alexy@localhost)
	by angle.badbox.com (8.12.5/8.12.5) id g9RFUnDK005679
	for linux-scsi@vger.kernel.org; Sun, 27 Oct 2002 10:30:49 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Now that I got all those drives spinning, I'm eager to try out 
a RAID array.  I reckon it's a better way to hedge against disk
failures than backups on tape -- even 20/40 GB dds4 or DLT is
not enough those days, and loading/rotating is tedious.

I heard an opinion that software RAID on Linux with SCSI is
"almost" as good as a hardware controller.  What is the experience
here?  Also, since I'm running LVM throughout, including the root
partition, does RAID coexist well with LVM?

But if I go the way of the hardware controller, is it better
to get a separate one, or one of those new cards from Adaptec
which say they have a Host RAID 0/1 or some such?

I'm looking at a 3 drives RAID to begin with, perhaps 4.

-- 
Cheers,
Alexy Khrabrov :: www.setup.org :: Age Quod Agis
