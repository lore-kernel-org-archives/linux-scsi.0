From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5685] New: Symbios Logic 53c1030 Driver Not
 Running
Date: Thu, 19 Jan 2006 02:44:17 -0800
Message-ID: <20060119024417.1d624afc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:10144 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161355AbWASKom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 05:44:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>



Begin forwarded message:

Date: Thu, 1 Dec 2005 01:03:09 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5685] New: Symbios Logic 53c1030 Driver Not Running


http://bugzilla.kernel.org/show_bug.cgi?id=5685

           Summary: Symbios Logic 53c1030 Driver Not Running
    Kernel Version: 2.6.14
            Status: NEW
          Severity: normal
             Owner: andmike@us.ibm.com
         Submitter: lyxmoo@gmail.com


Most recent kernel where this bug did not occur:2.6.12
Distribution: Regular Redhat AS4u2
Hardware Environment: Dell 1850/2850/ vmware LSI scsi
Software Environment: 
gcc version 3.4.4

Problem Description:
with general kernel 2.6.14 package from kernel.org, the Fusion MPT (base + 
ScsiHost) drivers not running on SCSI storage controller: LSI Logic / Symbios 
Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08) 

with dynamic module loaded by initrd image, that will not driven the scsi.

back port the elder version Fusion MPT driver from 2.6.11 then OS running 
normal. 

Steps to reproduce:
compile kernel by modularize select MPT driver;
make  initrd  image;
restart OS,
the System will be panic preferred: kernel panic no syncing

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
