From: Vinh Ly <vly@ucsd.edu>
Subject: HIGHMEM64G
Date: Fri, 21 Nov 2003 21:47:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.SGI.4.05.10311212131330.249876-100000@jupiter.ucsd.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jupiter.ucsd.edu ([132.239.126.151]:45566 "EHLO
	jupiter.ucsd.edu") by vger.kernel.org with ESMTP id S261996AbTKVFaO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 00:30:14 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


kernel=2.6.0-test3-bk2 (SMP)
distro=RedHat 9 
glibc=2.3.2-27.9
controller driver=gdth.o

When I compile the kernel w/ HIGHMEM64G=y, it will fail to boot, and 
the error message is:

        Kernel panic: No init found.  Try passing init= option to kernel

Using the kernel option mem with a number less than
4 GB will boot fine, ie, mem=3500M.
It's no problem when I compile it w/ HIGHMEM4G=y.

The problem started w/ the 2.6.0-test3-bk2 kernel.
(I have tried test9-bk25 and it didn't make any difference.)
I noticed a lot of changes in the SCSI subsystem codes in test3-bk2,
and I'm guessing that something in there is breaking this functionality.

Any ideas?

Thank you,

vl
v.t.ly@ieee.org

P.S.  The 2.4.22 kernel works OK.

