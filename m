From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: IOs stuck in SG
Date: Sat, 2 Jun 2007 03:56:03 +0800 (CST)
Message-ID: <894089.97203.qm@web63904.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web63904.mail.re1.yahoo.com ([69.147.97.119]:26405 "HELO
	web63904.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762589AbXFAT4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 15:56:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I am seeing a problem where IOs get stuck in SG for a _long_ time. The 

initiator driver is our own, and we dont see any IOs in there that are 

pending. We are running 2.4.30.  

 

This is what I see in the proc file for SG. The act: acc to documentation means: 

act: mid level (adapter driver or device) has command. 

 

Has anyone seen this problem? If yes, is there a patch for this problem? 

 

>>> device=sg97 scsi4 chan=0 id=17 lun=0   em=0 sg_tablesize=64 excl=0 

   FD(1): timeout=60000ms bufflen=4096 (res)sgat=0 low_dma=0 

   cmd_q=1 f_packid=1 k_orphan=0 closed=0 

     act: id=1856404224 blen=8 t_o/elap=15000/54615000ms sgat=0 op=0x25 

 >>> device=sg98 scsi4 chan=0 id=18 lun=0   em=0 sg_tablesize=64 excl=0 

   FD(1): timeout=60000ms bufflen=4096 (res)sgat=0 low_dma=0 

   cmd_q=1 f_packid=1 k_orphan=0 closed=0 

     act: id=1883362756 blen=255 t_o/elap=15000/54474000ms sgat=0 op=0x1c 

 

 

-- Mark 












 
____________________________________________________________________________________
Need Mail bonding?
Go to the Yahoo! Mail Q&A for great tips from Yahoo! Answers users.
http://answers.yahoo.com/dir/?link=list&sid=396546091
