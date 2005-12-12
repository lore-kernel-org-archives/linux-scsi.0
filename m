From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bug 4940] Repeatable Kernel Panic on Adaptec 2015S I20 device
 on bootup
Date: Mon, 12 Dec 2005 12:17:21 -0800
Message-ID: <20051212121721.0a84c990.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:17303 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932218AbVLLURm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 15:17:42 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id jBCKHcDZ030754
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2005 12:17:38 -0800
Received: from bix (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id jBCKHaZJ013417
	for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2005 12:17:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Mon, 12 Dec 2005 10:55:11 -0800
From: bugme-daemon@bugzilla.kernel.org
To: akpm@osdl.org
Subject: [Bug 4940] Repeatable Kernel Panic on Adaptec 2015S I20 device on bootup


http://bugzilla.kernel.org/show_bug.cgi?id=4940





------- Additional Comments From felix.seeger@gmx.de  2005-12-12 10:47 -------
I have a problem with 2.6.14.3 and the dpti driver with an Adaptec 2100S card.  
  
During boot I get:  
iop0: controller found  
PCI: Unable to reserv mem region ... for device ...(iop0)  
iop0: device already claimed  
iop0: DMA/IO allocation fopr I2O controller failed  
...  
...  
dpti0: Trying to abort cmd=56  
 
The system hangs here, bootup with 2.6.8 debian stable works fine, I will now  
try older kernel versions.  The raid array and disks where detected correctly 
prior to the messages above. 
 
 

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
