From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [Bug]+[Patch] kernel oops after removing lld
Date: Fri, 16 May 2003 08:55:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305160855.56748.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate-5.de.ibm.com ([194.196.100.238]:54438 "EHLO
	d12lmsgate-5.de.ibm.com") by vger.kernel.org with ESMTP
	id S264325AbTEPGvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2003 02:51:17 -0400
Received: from d12relay01.de.ibm.com (d12relay01.de.ibm.com [9.165.215.22])
	by d12lmsgate-5.de.ibm.com (8.12.9/8.12.8) with ESMTP id h4G742lr052582
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2003 09:04:02 +0200
Received: from osiris (osiris.boeblingen.de.ibm.com [9.152.242.25])
	by d12relay01.de.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h4G742Ew071744
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2003 09:04:02 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all again, 

>I got a kernel oops when doing the following:
> 
>modprobe <lowleveldriver>
>rmmod <lowleveldriver>
>ls -al /proc/scsi
 
actually I got the kernel oops with kernel 2.4.20 and ported 
my patch (which doesn't work anyway) to 2.4.21-rc2 without 
thinking too much. But it looks like this bug has been fixed. 
Maybe I should read the code more carefully next time :) 

duh..., 
Heiko 

