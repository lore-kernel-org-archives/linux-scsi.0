From: Andrew Morton <akpm@osdl.org>
Subject: sym2 probs in bk-scsi tree
Date: Wed, 7 Apr 2004 23:18:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040407231820.66dd76cd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:6352 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261992AbUDHGSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 02:18:30 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@debian.org>


This is on the power4 machine, which has previously worked quite happily.

During boot the system spends maybe one minute dicking with the SCSI
controller and emitting scary new reset and abort messages.


scsi(0:0:10:0): Beginning Domain Validation                       
sym0:10: wide asynchronous.                
sym0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:10:0): Ending Domain Validation                     
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:11:0: tagged command queuing enabled, command queue depth 16. 
scsi(0:0:11:0): Beginning Domain Validation                       
sym0:11: wide asynchronous.                
sym0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:11:0): Ending Domain Validation                     
  Vendor: IBM       Model: HSBPD4E  PU3SCSI  Rev: 0013
  Type:   Enclosure                          ANSI SCSI revision: 02
scsi(0:0:15:0): Beginning Domain Validation                        
sym0:15:0:phase change 6-7 6@28050390 resid=4.
sym0:15:0:phase change 6-7 5@28050390 resid=3.
sym0:15:0:phase change 6-7 9@28050390 resid=7.
sym0:15:0:phase change 6-7 6@28050390 resid=4.
sym0:15:0: DEVICE RESET operation started.    
sym0:15:0: DEVICE RESET operation complete.
sym0:15:control msgout: c.                 
sym0: TARGET 15 has been reset.
sym0:15:0: ABORT operation started.
sym0:15:0: ABORT operation complete.
sym0:15:0: BUS RESET operation started.
sym0:15:0: BUS RESET operation complete.
sym0: SCSI BUS reset detected.          
sym0: SCSI BUS has been reset.
sym0:15:0: DEVICE RESET operation started.
sym0:15:0: DEVICE RESET operation complete.
sym0:15:control msgout: c.                 
sym0: TARGET 15 has been reset.
sym0:15:0: ABORT operation started.
sym0:15:0: ABORT operation complete.
sym0:15:0: BUS RESET operation started.
sym0:15:0: BUS RESET operation complete.
sym0: SCSI BUS reset detected.          
sym0: SCSI BUS has been reset.
sym0:15:0: DEVICE RESET operation started.
sym0:15:0: DEVICE RESET operation complete.
sym0:15:control msgout: c.                 
sym0: TARGET 15 has been reset.
sym0:15:0: ABORT operation started.
sym0:15:0: ABORT operation complete.
sym0:15:0: BUS RESET operation started.
sym0:15:0: BUS RESET operation complete.
sym0: SCSI BUS reset detected.          
sym0: SCSI BUS has been reset.
scsi(0:0:15:0): Domain Validation skipping write tests
scsi(0:0:15:0): Ending Domain Validation              
sym1: <1010-66> rev 0x1 at pci 0000:41:01.1 irq 104
sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: SCSI BUS has been reset.                     
scsi1 : sym-2.1.18j           
sym2: <875> rev 0x3 at pci 0001:21:01.0 irq 117
sym2: No NVRAM, ID 7, Fast-20, SE, parity checking
sym2: SCSI BUS has been reset.                    
scsi2 : sym-2.1.18j           
st: Version 20040318, fixed bufsize 32768, s/g segs 256
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sda: drive cache: write through               
 sda: sda1 sda2 sda3 sda4 < sda5 >         
