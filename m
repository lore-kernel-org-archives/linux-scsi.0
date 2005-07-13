From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4880] New: dpt_i2o.c does not register itself
 with sysfs
Date: Wed, 13 Jul 2005 12:32:50 -0700
Message-ID: <20050713123250.5d3e3298.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:48064 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262604AbVGMTdd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 15:33:33 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id j6DJXWjA012155
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 12:33:32 -0700
Received: from bix (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id j6DJXV4d031111
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 12:33:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Wed, 13 Jul 2005 09:10:10 -0700
From: bugme-daemon@kernel-bugs.osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4880] New: dpt_i2o.c does not register itself with sysfs


http://bugzilla.kernel.org/show_bug.cgi?id=4880

           Summary: dpt_i2o.c does not register itself with sysfs
    Kernel Version: 2.6.10
            Status: NEW
          Severity: normal
             Owner: andmike@us.ibm.com
         Submitter: ngroot@imsa.edu


Distribution: Fedora Core 3
Hardware Environment: x86
Software Environment: 
Problem Description: The Adaptec I2O RAID driver (dpt_i2o.c) has a few character
devices with major number 151 that it uses to communicate with userspace
utilities.  These devices are not registered with sysfs, so udev can't pick them
up.  

Steps to reproduce:
1) Boot Linux on a machine with an Adaptec I2O RAID controller.  
2) Note that there's no "dev" file in class/scsi_host/hostX in sysfs.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
