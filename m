From: "dezheng shen" <dzshen@winbond.com>
Subject: [Winbond] MS/MS Pro driver for Winbond 528 PCI reader for public review
Date: Tue, 27 Jun 2006 16:07:59 +0800
Message-ID: <44A0E75F.4090800@winbond.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wehq.winbond.com.tw ([202.39.229.15]:44231 "EHLO
	wehq.winbond.com.tw") by vger.kernel.org with ESMTP
	id S1030738AbWF0II0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2006 04:08:26 -0400
Received: from wemlg.winbond.com.tw (wemlg [10.2.6.199])
	by wehq.winbond.com.tw (8.12.6/8.12.6) with ESMTP id k5R88OmS001284
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 16:08:24 +0800 (CST)
Received: from wehqims01.winbond.com.tw (wehqims01 [10.2.6.99])
	by wemlg.winbond.com.tw (8.12.10/8.12.10) with ESMTP id k5R881U5024107
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 16:08:01 +0800 (CST)
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear all:
   This email was originally posted on linux-kernel but I didn't get any 
response yet so that I post it to this linux-scsi again. Hope that we 
can get reply soon.

thank you,

dz

Dear all:
   Eventually, we found a place to place our sources for public review.

   Files are located in

http://zeniv.linux.org.uk/~winbond/

and they have been tested on Intel/AMD single/dual processors and Redhat 
9/Fedora 5 and Redhat workstation 4. We ran a stress test on multiple 
platforms overnight to read/write/format MS/MSPro cards via Winbond 528 
readers.

   Our customers, motherboard manufactures like ASUS, purchase Winbond 
528 then mount their motherboards. Winbond 528 itself provides many 
reader functions like MS/MSPro/SM/xD/SD/MMC and Winbond also vendors 
many other different chips for various buses. For example, Winbond 518 
is for LPC bus and 488 is for embedded hooked up to data bus directly. 
Our team is to derive a simple and unified architecture so that we don't 
have to write redudant codes for each chip, like 518/528/528DA and 488. 
Another example is, wbtable.c and wbtable.h are also used on xD/SM drivers.

   Someone might wonder why we use SCSI subsystem to implement those 
device drivers? When we are assigned this job in 2004, the previous 
engineer has been working on this device driver for over a year and 
he/she was using SCSI subsystem and we don't know why and we simply 
follow her/his trace to deliver this driver to our customers as soon as 
we can. Also, when we plug similar USB flash memory readers, it shows 
sda/sdb so that we took the same approach as SCSI devices.

   Don't hesitate to ask if you have any questions.

best regards,

dz



===========================================================================================
The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such  a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Winbond is strictly prohibited; and any information in this email irrelevant to the official business of Winbond shall be deemed as neither given nor endorsed by Winbond.
