From: Kernel The <erforschen_linux@yahoo.com>
Subject: RAW I/O
Date: Mon, 28 Jun 2004 22:34:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040629053446.73235.qmail@web90102.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web90102.mail.scd.yahoo.com ([66.218.94.73]:59741 "HELO
	web90102.mail.scd.yahoo.com") by vger.kernel.org with SMTP
	id S263826AbUF2Fer (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2004 01:34:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have written a RAM disk driver and I want to write
the data to a backup disk/partition while unloading
the driver.

I want to do RAW I/O to a disk/partition from my ram
disk driver. How I can achieve this?

alloc_kiovec(..), map_user_kiobuf(...) and
brw_kiovec(...) functions can be used for this? But
these function map user space into kernel space
memory, but in my driver I will be having only kernel
space memory.

Thanks in advance!
Erforschen


		
__________________________________
Do you Yahoo!?
Yahoo! Mail - 50x more storage than other providers!
http://promotions.yahoo.com/new_mail
