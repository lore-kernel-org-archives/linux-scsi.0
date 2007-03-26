From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: Disabling block layer
Date: Mon, 26 Mar 2007 12:59:13 -0700 (PDT)
Message-ID: <656559.33072.qm@web63001.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web63001.mail.re1.yahoo.com ([69.147.96.212]:32432 "HELO
	web63001.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751165AbXCZUFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Mar 2007 16:05:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!

I had a question about disabling the block layer for SCSI devices. We
have an embedded device, and it runs 2.4.30. We need to be able to
support a lot of SCSI devices (in the thousands) for our device, and we
talk to the devices via SG. We are facing a memory allocation problem
after discovering a few thousand devices. For every device,  there
seems to be a lot of memory allocated in the block layer. This memory
includes cache memory (which IIRC is reclaimable by the kernel memory
subsystem when it needs it) and also pages that are used for the
alloc_pages pool.



My questions were relating to disabling the block layer for the
devices. We always talk direct passthrough to the storage(except the
local hard disk),  and do not need the block layer at all. 

1. Is there a way to disable the block layer for specific devices?

2. If yes, how can that be done, and  are there any gotchas associated with that?



Thanks!

M


 
____________________________________________________________________________________
Never miss an email again!
Yahoo! Toolbar alerts you the instant new Mail arrives.
http://tools.search.yahoo.com/toolbar/features/mail/
