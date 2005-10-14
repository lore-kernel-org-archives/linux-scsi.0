From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5440] New: Perc4 megaraid: module doesn't
 detect cache memory and writeback mode
Date: Fri, 14 Oct 2005 10:11:07 -0700
Message-ID: <20051014101107.3d8e39b9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:26500 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750735AbVJNRLu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 13:11:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>


(Could we pleeeeze have a megaraid entry in the MAINTAINERS file?)

Begin forwarded message:

Date: Fri, 14 Oct 2005 03:52:20 -0700
From: bugme-daemon@kernel-bugs.osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5440] New: Perc4 megaraid: module doesn't detect cache memory and writeback mode


http://bugzilla.kernel.org/show_bug.cgi?id=5440

           Summary: Perc4 megaraid:  module doesn't detect cache memory and
                    writeback mode
    Kernel Version: 2.6.9 -> 2.6.13
            Status: NEW
          Severity: high
             Owner: andmike@us.ibm.com
         Submitter: spirit@cscup.com


Most recent kernel where this bug did not occur:
Distribution: debian sarge - gentoo 2005
Hardware Environment: Dell Poweredge 2850 Perc4
Software Environment:
Problem Description:

kernel doesn't detect cache memory of Perc4 card and go in write through mode.

writing performances are really bad. (i have a raid10 with 6 disks)

here the dmesg:


> megaraid: fw version:[513O] bios version:[H418]
> scsi0 : LSI Logic MegaRAID driver
> scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
> scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
>   Vendor: PE/PV     Model: 1x8 SCSI BP       Rev: 1.0
>   Type:   Processor                          ANSI SCSI revision: 02
> scsi[0]: scanning scsi channel 2 [virtual] for logical drives
>   Vendor: MegaRAID  Model: LD 0 RAID5  139G  Rev: 513O
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> SCSI device sda: 286228480 512-byte hdwr sectors (146549 MB)
> sda: asking for cache data failed
> sda: assuming drive cache: write through

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
