From: Alan Stern <stern@rowland.harvard.edu>
Subject: What is SCSI command 0xa0 ?
Date: Mon, 14 Feb 2005 16:07:05 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502141558290.1175-100000@ida.rowland.org>
References: <20050214160210.6c7e7e52@hebus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:23300 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261473AbVBNVHG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 16:07:06 -0500
In-Reply-To: <20050214160210.6c7e7e52@hebus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Samuel Colin <Samuel.Colin3@wanadoo.fr>

Can anybody tell me what this CDB is supposed to do, when issued to a 
direct-access device (a disk drive)?

	a0 00 00 00 00 00 00 00 10 00 00 00

It's crashing the firmware on Samuel's disk and generally causing 
problems.  The command gets sent right after the partition table is 
read.

Equally important, can someone suggest how to suppress the command?

Thanks,

Alan Stern

P.S.: Samuel, that one command seems to be causing all your problems.  
For some reason it gets sent to the lacie1 disk and not to the lacieroot
disk.  I think the USB controller is working okay and has nothing to do 
with this.  Maybe the command is sent by some daemon running on the 
openbrick system, like hald.  Is there a hald process, and if you kill the 
process does the disk then start working?

