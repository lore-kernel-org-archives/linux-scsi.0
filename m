From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 04 Dec 2003 14:34:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070573684.2269.37.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:35554 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263533AbTLDVzS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 16:55:18 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>, SCSI development list <linux-scsi@vger.kernel.org>

> Pat LaVarre says that protocols x02 (SFF-8020i = CD/DVD) and 
> x05 (SFF-8070i = Removeable media, floppy) are the most important, since
> they are the only other ones the generic Windows USB mass storage drivers
> recognize.

I mean to be paraphrasing the windows/inf/usbstor.inf quotation:

...
[Generic] 
%GenericBulkOnly.DeviceDesc%=USBSTOR_BULK, USB\Class_08&SubClass_02&Prot_50 
%GenericBulkOnly.DeviceDesc%=USBSTOR_BULK, USB\Class_08&SubClass_05&Prot_50 
%GenericBulkOnly.DeviceDesc%=USBSTOR_BULK, USB\Class_08&SubClass_06&Prot_50 

[...

>From that quotation I ignorantly guess that plugging anything other than
x 08 (02|05|06) 50 into Win XP/ 2K/ ME requires an idVendor:idProduct
match (possibly already found elsewhere in Windows e.g. elsewhere in
that same file), else installing a driver (possibly as trivial as
additional .inf text) to match the device.

Pat LaVarre


