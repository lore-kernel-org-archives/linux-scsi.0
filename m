From: "Adam Radford" <aradford@amcc.com>
Subject: RE: [BK-PATCH] 3w-9xxx: proc interface
Date: Wed, 7 Jul 2004 11:27:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <I0HVAW03.QOA@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:41386 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S265281AbUGGS2K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2004 14:28:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>, Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

Rick,

There should be a beta version of 3dm2 & tw_cli that will work with the in-kernel
3w-9xxx driver on the 3ware website sometime this week.  
I'd rather not re-add deprecated interfaces.

-Adam

-----Original Message-----
From: Ricky Beam [mailto:jfbeam@bluetronic.net]
Sent: Friday, July 02, 2004 11:42 AM
To: Christoph Hellwig
Cc: Adam Radford; Linux SCSI List
Subject: Re: [BK-PATCH] 3w-9xxx: proc interface


On Fri, 2 Jul 2004, Christoph Hellwig wrote:
>On Fri, Jul 02, 2004 at 12:08:23PM -0400, Ricky Beam wrote:
>> 3dm2 (the currently available one anyway) needs /proc/scsi/3w-9xxx to
>> discover any controllers.  The current in-kernel driver doesn't contain any
>> /proc/scsi support.  The attached patch restores the interface.
>
>I'd rather wait for a new 3dm2 release instead of adding deprecated interfaces.
>Adam, any schedule for a new release?

Well, I'm not the only one who cannot monitor/control their array with the
current in-kernel driver.  I don't care if the proc interface makes it
back into the kernel; the systems I assemble with a 9500 will have the
proc interface restored until I have a 3dm2 in hand that doesn't need it.

Having a non-functioning 3dm2 is a major problem in my book. (technically,
not have a firmware update interface in the kernel's driver is also a
concern.)

Locking the door before you have a key to get back in is a bad idea.

--Ricky



