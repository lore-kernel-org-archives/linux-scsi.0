From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4406] New: Kernel panic when load DMX3191D
 module on kernel 2.6
Date: Sun, 27 Mar 2005 16:28:10 -0800
Message-ID: <20050327162810.34808aa2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:29860 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261638AbVC1A2U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2005 19:28:20 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id j2S0SIs4003086
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2005 16:28:19 -0800
Received: from bix (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id j2S0SIQm029880
	for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2005 16:28:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Sat, 26 Mar 2005 13:54:14 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4406] New: Kernel panic when load DMX3191D module on kernel 2.6


http://bugme.osdl.org/show_bug.cgi?id=4406

           Summary: Kernel panic when load DMX3191D module on kernel 2.6
    Kernel Version: 2.6.0 to lastest 2.6.11
            Status: NEW
          Severity: high
             Owner: andmike@us.ibm.com
         Submitter: michel_paquet@hotmail.com


Distribution: All

Hardware Environment: Pentium 3@933Mhz, Asus CUSL2-C, 512Mo RAM, Domex DMX3191D 
(Domex 536 chip, UDS-IS11 PC/PCI - PN:530268-02) SCSI Adapter and Umax Astra 
1200S Scanner

Software Environment: KDE, Gnome

Problem Description: When I load with modprobe the dmx3191d module, the module 
load fine. But when I try to access to the scanner atteched to the card, xsane 
hang. I try in console to find the scanner (UMAX Astra 1200S) with the sane-
find-scanner script and he didn't found anything. Sometime the command just 
hang instate to found nothing and sometime, he can find the scanner (but not 
always).  

Reproducible: Always
Steps to Reproduce:
1. Compile your kernel with SCSI and SG hard (tested in modules too with sames 
errors)
2. Make DMX3191D in module
3. restart with the new kernel, load the dmx3191d modules and launch sane-find-
scanner, launch xsane on X environment

Actual Results:  
sane-find-scanner found most of time the scanner, xsane hang and after 2 or 3 
minute when I try to numerise and the kernel become in panic, all the system 
crash

Expected Results:  
juste work and stop hang or crash or whatever. This bug is not present on 
kernel 2.4.x

I have try all kernel from 2.6.x tree (from 2.6.0 to 2.6.11, and he always do 
the same error. From 2.6.0 to 2.6.9, the kernel always make a "Kernel Panic". 
But with 2.6.10 and 2.6.11, the module loaded but it is when I have to access 
to the scanner, the system hang and the kernel make a panic message

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
