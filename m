From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: What is SCSI command 0xa0 ?
Date: Mon, 14 Feb 2005 15:12:03 -0600
Message-ID: <200502142112.j1ELC3bY032759@falcon30.maxeymade.com>
References: <Pine.LNX.4.44L0.0502141558290.1175-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from falcon30.maxeymade.com ([24.173.215.190]:56457 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S261474AbVBNVMK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 16:12:10 -0500
In-reply-to: <Pine.LNX.4.44L0.0502141558290.1175-100000@ida.rowland.org> 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Samuel Colin <Samuel.Colin3@wanadoo.fr>


On Mon, 14 Feb 2005 16:07:05 EST, Alan Stern wrote:
>Can anybody tell me what this CDB is supposed to do, when issued to a 
>direct-access device (a disk drive)?
>
>	a0 00 00 00 00 00 00 00 10 00 00 00

Looks like an ATAPI TUR.

>
>It's crashing the firmware on Samuel's disk and generally causing 
>problems.  The command gets sent right after the partition table is 
>read.
>
>Equally important, can someone suggest how to suppress the command?
>
>Thanks,
>
>Alan Stern
>
>P.S.: Samuel, that one command seems to be causing all your problems.  
>For some reason it gets sent to the lacie1 disk and not to the lacieroot
>disk.  I think the USB controller is working okay and has nothing to do 
>with this.  Maybe the command is sent by some daemon running on the 
>openbrick system, like hald.  Is there a hald process, and if you kill the 
>process does the disk then start working?
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


