From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/1] scsi: expose AN support to user space
Date: Mon, 15 Oct 2007 14:12:15 -0400
Message-ID: <4713AD7F.8030906@garzik.org>
References: <200710032104.l93L40CM008614@imap1.linux-foundation.org> <470FE29A.7050605@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46196 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbXJOSMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 14:12:18 -0400
In-Reply-To: <470FE29A.7050605@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi <linux-scsi@vger.kernel.org>
Cc: akpm@linux-foundation.org, kristen.c.accardi@intel.com, htejun@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

Jeff Garzik wrote:
> akpm@linux-foundation.org wrote:
>> From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
>>
>> If a scsi_device supports async notification for media change, then 
>> let user
>> space know this capability exists by creating a new sysfs entry
>> "media_change_notify", which will be 1 if it is supported, and 0 if not
>> supported.  Create a routine which allows scsi devices to send a 
>> uevent when
>> media change events occur.
>>
>> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
>> Acked-by: Jeff Garzik <jeff@garzik.org>
>> Cc: Tejun Heo <htejun@gmail.com>
>> Cc: James Bottomley <James.Bottomley@steeleye.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Ping?

Re-Ping?

This patch works (it has been working for months), is ACK'd by me, 
addresses some of the feedback given in August, and has not received any 
comments despite the SCSI maintainers being To'd or CC'd for weeks 
(months, if you include the older thread).

Further, this patch is required to round out interrupt-driven media 
change notification, that which eliminates the CD-ROM polling that 
userspace has done since the dawn of time.

It was not in the merge window SCSI push, while being in -mm for a while 
and linux-scsi having the patch for a while.  Which means, if the 
silence continues, it must wait 4-6 months for 2.6.25 release, for no 
apparent reason.

	Jeff


