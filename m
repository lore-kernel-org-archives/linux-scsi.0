From: "David Fish" <dfish@broadbus.com>
Subject: controlling block alignment and length in SCSI sd I/O operations
Date: Tue, 11 Nov 2003 11:06:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3B83C5E7EAB53F44A16CDFB70F9E4BF3A1F0FF@btiexch01.broadbus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [12.25.43.10] ([12.25.43.10]:23348 "EHLO btiexch01.broadbus.com")
	by vger.kernel.org with ESMTP id S263561AbTKKQGj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 11:06:39 -0500
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all,

Here's a newbie-type question which I hope is appropriate to the list:

I'm running a QLogic fibre channel HBA (qla2310F) in a PC running RedHat
8.0 Linux.  The device to which I'm directly connected can only accept
SCSI commands with 2KB granularity, which means, for example, that a
READ must have the logical block address fall on a 2KB boundary and the
length must be in 2KB increments.

When I load the QLogic driver, the FC login activity happens w/ no
problem, but when the driver issues the first SCSI READ commands, the
number of blocks requested is 2 (1KB), to which the device returns a
CHECK CONDITION, citing an invalid field in the CDB.

The device vendor claims that the device can run with the QLogic HBA
under RH9.0 Linux, which I'm about to try.  The question I have, then,
is this:  is it possible to configure the Linux SCSI subsystem to
satisfy this vendor's 2KB data alignment requirement?  Or is this
handled at the HBA driver level?  And is this type of alignment
requirement standard for RAID controllers and disk arrays?

TIA and Regards,
Dave Fish
 
--------------------------------------------------------

 
This email message and any files transmitted with it contain confidential information intended only for the person(s) to whom this email message is addressed.  If you have received this email message in error, please notify the sender immediately by telephone or email and destroy the original message without making a copy.  Thank you. 
 
