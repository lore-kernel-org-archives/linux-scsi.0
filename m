From: "dezheng shen" <dzshen@winbond.com>
Subject: Winbond flash memory reader SCSI device drivers
Date: Mon, 12 Jun 2006 14:34:06 +0800
Message-ID: <448D0ADE.8070303@winbond.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wehq.winbond.com.tw ([202.39.229.15]:16556 "EHLO
	wehq.winbond.com.tw") by vger.kernel.org with ESMTP
	id S1750846AbWFLGfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2006 02:35:12 -0400
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dzshen@winbond.com, sjin@winbond.com, James Bottomley <James.Bottomley@SteelEye.com>, Russell King <rmk@arm.linux.org.uk>

Dear all:
  We would like to contribute our flash memory device drivers to Linux 
community and would like to post to a public list for review first.

  Since our drivers are implemented using SCSI subsystem so that our 
driver sources should go to ./drivers/scsi. If possible, can we create a 
subdirectory in ./drivers/scsi named "winbond" because we have drivers 
for SD/MMC/MS/MSPRO/xD/SM for various Winbond chips. It might be easier 
for us to maintain our own subdirectory.

  This is the first we send this request to this mailing list and we are 
not sure this is the right way to do. If any of you is interested in 
reviewing our sources for Memory Stick driver for Winbond w518 chip, 
please let me know so that we can post our sources.

thank you,

dz
 


===========================================================================================
The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such  a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Winbond is strictly prohibited; and any information in this email irrelevant to the official business of Winbond shall be deemed as neither given nor endorsed by Winbond.
