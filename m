From: "Thayne Harmon" <THARMON@novell.com>
Subject: question scsi_register verses register_blkdev
Date: Fri, 20 Oct 2006 12:25:24 -0600
Message-ID: <4538C032.8E7F.00B8.0@novell.com>
References: <861B5CF71BC70C478DFEB9EAFE98F699ACA42C@G3W0068.americas.hpqcorp.net>
 <20061020172549.7666.qmail@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34004 "EHLO
	victor.provo.novell.com") by vger.kernel.org with ESMTP
	id S964828AbWJTSZd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 14:25:33 -0400
In-Reply-To: <20061020172549.7666.qmail@web31812.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

If this is the wrong list, please direct me to the appropriate one, thank you.

I am trying to write a linux driver (I'm new at this) for a standard SCSI host bus adapter.
I have read the Linux Device Drivers book 3rd ed., searched the web and read this list.
I do not understand when one should use 'scsi_register' or 'register_blkdev', or does one use both?
In searching the kernel source, it seems that most of the drivers use scsi_register,
while the device modules sr, sd, etc. use register_blkdev.

The book however never mentions scsi_register as part of a driver.

Could someone give me a clue on this?

Best regards,

Thayne Harmon


