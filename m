From: Steve Sutphen <steve@cs.ualberta.ca>
Subject: LSI MegaRAID on Tyan S2469 MB
Date: Thu, 29 Jan 2004 05:53:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <S560698AbUA2MxV/20040129125322Z+855@sunkay.cs.ualberta.ca>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sunkay.cs.ualberta.ca ([129.128.4.11]:9390 "EHLO
	sunkay.cs.ualberta.ca") by vger.kernel.org with ESMTP
	id S265981AbUA2MxX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 07:53:23 -0500
Received: (from localhost user: 'steve' uid#10 fake: STDIN (steve@snaring))
	by sunkay.cs.ualberta.ca id S560698AbUA2MxV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 05:53:21 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: philipl@aslan.ab.ca

I am having a difficult problem with an LSI MegaRAID 320-2 that is installed
on a Tyan S2469 mother board with AMD Athlon's.  The disks that I am using
are Seagate 147GB drives. 
The problem is that the MegaRAID slows to a crawl, and then slows so much
that it times out and cannot complete the queued commands (for ever it
seems).
I have verified that the controller is working.  I have not been able to 
get it to fail when I move the controller, disk array, and boot disk 
to a different system with a Tyan S2466 motherboard (and dual Athlon's).

Some things that I have tried include: replacing the S2469 motherboard
with another copy of the same.  I have upgraded the BIOS code on the 
motherboard to the latest version V1.07.  I have upgraded the firmware 
on the LSI MegaRAID to the latest version on their web site.  I have 
tried a 2.4.18, a 2.4.23 and a 2.4.34 Linux kernel.  I have tried an
earlier version (I cannot check right now to see which one--what ever
came standard in the 2.4.23 kernel) and have upgraded to the 2.0.9 
version of the megaraid2 driver (I see that a 2.0.10 is now out, I
will try it tomorrow).  I have tried the system with just one CPU.
I have switched the CPU's with the ones on the S2466 based system mentioned
above.  I have replaced all the memory.  I not only have tested the disk
arrays by installing them in the S2466 based system, I have also hooked
them up to the on-board SCSI on the S2469 motherboard, and have
run bonnie++ testing with three of the drives in parallel (i.e. three
bonnie++ jobs in the background).  

My current theory is that there is some sort of incompatibility between
that motherboard (or perhaps the AMD chipset) and the LSI Logic MegaRAID
controller.  

Does anyone have a similar system that is working?  Has anyone encountered
similar problems?  What should I do next?

Thank you.
	steve@cs.ualberta.ca.

PS I have on occasion had the system running for long enough that I could 
complete a test.   When I did I found the performance was not up to 
what I expected.  Sequential writes to a 3-disk RAID-5 array were
14MB/s, re-writes were 7.5MB/s and reads were 48MB/s.  Are these 
reasonable?
	ss.

