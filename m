From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Fri, 29 Oct 2004 12:46:06 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410291245050.2411-100000@ida.rowland.org>
References: <4182520B.3060701@micro.ee.nthu.edu.tw>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4868 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263426AbUJ2QqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 12:46:06 -0400
In-Reply-To: <4182520B.3060701@micro.ee.nthu.edu.tw>
List-Id: linux-scsi@vger.kernel.org
To: Darsen <darsen@micro.ee.nthu.edu.tw>
Cc: Eero Volotinen <eero@ping-viini.org>, Adriaan Penning <a.penning@luon.net>, Andries Brouwer <aebr@win.tue.nl>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 29 Oct 2004, Darsen wrote:

> I tested the patch on 2.6.9 and everything works fine.
> There are some error messages, but I believe they already existed before 
> the patch was applied :)
> 
> -------------<dmsg part 1>-----------
> 
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x12f R 0 Stat 0x0
> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.
> sda : odd number of sectors reported, decreasing by one.
> SCSI device sda: 251904 512-byte hdwr sectors (129 MB)
> sda: assuming Write Enabled
> sda: assuming drive cache: write through
> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command TEST_UNIT_READY (6 bytes)

This looks very good.  Thanks for doing the test.

And yes, those other error messages are completely normal.

Alan Stern

