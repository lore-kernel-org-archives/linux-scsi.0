From: joystick <joystick@shiftmail.org>
Subject: How to reset a single drive?
Date: Tue, 13 Mar 2012 17:44:35 +0100
Message-ID: <4F5F7973.7000007@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:3330 "EHLO
	blade3.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab2CMSSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 14:18:39 -0400
Received: from [192.168.7.52] ([155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.5-x6 #31988)
 with ESMTPSA id <01OD2QCLFEA2L36XGG@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Tue, 13 Mar 2012 17:44:36 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,
it just happened that there was an unresponsive HDD in the system (a WD 
RE3 1TB SATA drive).
Multiple reboots of the machine (not poweroffs) did not revive it, and 
the server did not create a /dev device for it on subsequent reboots. So 
I thought it had failed.
But when I tried removing and inserting it in another hot-swap slot it 
started working again. After reinserting it in the original slot also it 
was working.
Probably a poweroff of the server would also have revived it.
FWIW: smartctl -x tells no error is logged by the drive.
It could also have been a controller glitch maybe?

For a future time, I know there are SCSI reset messages which can be 
sent to various things in the path to the drive. Could someone teach me 
how to send a reset message to the controller card, to a slot and/or to 
a drive, from bash?
Or any other suggestion for reviving a slot / drive which do not imply 
powering off the machine?

Our controller is LSI 6201-16i. No SAS expanders. I am able to determine 
the phy port number of the unresponsive drive.

Thanks for suggestions
J.
