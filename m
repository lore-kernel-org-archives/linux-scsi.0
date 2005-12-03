From: Denny Page <denny@cococafe.com>
Subject: Adaptec aix79xx performance
Date: Fri, 02 Dec 2005 23:35:44 -0800
Message-ID: <43914AD0.2050007@cococafe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:8842 "EHLO mail.cococafe.com")
	by vger.kernel.org with ESMTP id S1751186AbVLCHfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Dec 2005 02:35:45 -0500
Received: from marvin.cococafe.com (gw.cococafe.com [64.142.30.237])
	by mail.cococafe.com (Postfix) with ESMTP id 740B8590
	for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2005 23:35:45 -0800 (PST)
Received: from [192.168.0.2] (marvin.cococafe.com [192.168.0.2])
	by marvin.cococafe.com (Postfix) with ESMTP id D8AFDB03
	for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2005 23:35:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

I have a question regarding the support condition of the aic79xx driver.

I am running kernel version 2.6.14 (gentoo) on a dual processor system 
PCI-X system.  I am using an Adaptec scsi adapter to run an HP Ultrium 
tape drive.  Nothing else is attached to the controller.

I was previously using an Adaptec 29160N (aic7892), which is a 32 bit, 
66Mhz controller.  With this controller, the tape was not able to 
maintain full streaming, or achieve full speed.  Average rate was 
approximately 27MB per second.  In order to address the performance 
problem, HP recommended that I change to a 64 bit U160 or U320 controller.

I've put in an Adaptec 29320ALP-R (aic7901), which is a 32 bit, 133Mhz 
controller.  With this controller, performance has dropped to an abysmal 
2.7MB per second!

I am running the controller at 133Mhz, but I have also tried locking it 
to 66Mhz with no effect.  I am using the same cable with both 
controllers, and the terminator is built into the cable.  Nothing stands 
out in /var/log/messages.

So, can anyone offer ideas as to why the 79xx controller performs at one 
tenth the rate of the 78xx controller and how to fix it?  Any help 
appreciated.

Thanks,

Denny


