From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Mon, 07 Nov 2005 19:06:54 +0100
Message-ID: <436F97BE.1030406@gmx.de>
References: <Pine.LNX.4.44L0.0511071244100.5078-100000@iolanthe.rowland.org>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:42890 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S965097AbVKGSG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 13:06:59 -0500
In-Reply-To: <Pine.LNX.4.44L0.0511071244100.5078-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Mon, 7 Nov 2005, Patrick Mansfield wrote:
> 
> 

> 
> I don't think blacklisting is a good way to do this.  In principle any USB 
> mass storage device -- any SCSI device, in fact -- might have a 
> vendor-specific pass-thru needing special handling.

no. that would be not industry best practice and uneconomical sw effort.
remember this devices are mainly "designed for windows" and WHQL certification 
is expensive for every single driver. and ms has only one driver for all usb storage 
right now, all boxes and sticks i had here use it.

>  It doesn't have to be 
> correlated with the vendor, the product, the SCSI level, the transport, or 
> anything else.

yes. the sheet for design recommended cypress chips state all ATACB and ATA-Security.
i would be make no sense to implement different behaviuors in chips for the same purpose.

> 
> Alan Stern
> 

tom schorpp
