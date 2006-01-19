From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5735] New: System boot hangs Adaptec 2100S
 card
Date: Thu, 19 Jan 2006 03:38:23 -0800
Message-ID: <20060119033823.1a5aca1e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51628 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161190AbWASLir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 06:38:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>



Begin forwarded message:

Date: Mon, 12 Dec 2005 11:14:26 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5735] New: System boot hangs Adaptec 2100S card


http://bugzilla.kernel.org/show_bug.cgi?id=5735

           Summary: System boot hangs Adaptec 2100S card
    Kernel Version: 2.6.14.3
            Status: NEW
          Severity: normal
             Owner: andmike@us.ibm.com
         Submitter: felix.seeger@gmx.de


During boot with an Adaptec 2100S card, 4 drives attached (1 single, 3 as 
raid5 array) the system hangs on Debian stable. 
 
 
Here is a part from the console I've written down: 
 
iop0: controller found   
PCI: Unable to reserv mem region ... for device ...(iop0)   
iop0: device already claimed   
iop0: DMA/IO allocation fopr I2O controller failed   
...   
...   
dpti0: Trying to abort cmd=56   
  
The system hangs here, bootup with 2.6.8 from Debian works fine, I am 
compiling older kernel versions atm. The raid array and disks where detected 
correctly prior to the messages above.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
