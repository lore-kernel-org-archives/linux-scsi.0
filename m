From: David Brownell <david-b@pacbell.net>
Subject: Re: usb-starge not working in the latest kernel 2.4
Date: Fri, 29 Aug 2003 07:50:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F4F682F.3010707@pacbell.net>
References: <Pine.LNX.4.44L0.0308290958190.824-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta7.pltn13.pbi.net ([64.164.98.8]:62136 "EHLO
	mta7.pltn13.pbi.net") by vger.kernel.org with ESMTP id S261258AbTH2Opc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 10:45:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.0308290958190.824-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Alan Stern wrote:
> On Fri, 29 Aug 2003, Tomita, Haruo wrote:
> 
>>usb-storage: Command READ_10 (10 bytes)
>>usb-storage: 28 00 00 02 e5 24 00 00 3f 00 00 00
>>usb-storage: Bulk command S 0x43425355 T 0x7862f8 Trg 0 LUN 0 L 129024 F 128 CL 12
>>usb-storage: command_abort() called
> 
> 
> It stopped working here.  The driver tried to send the next command but 
> the drive never acknowledged receiving it.

It might also be useful to find just how many of those 126 KBytes
were successfully transferred before the abort.

Also:  is this one of those cases where 2.6 works and 2.4 doesn't?
The i/o patterns are very different ...


> Did you said that the device works well when connected through a high
> speed hub, but it fails when connected directly to the computer?  That's a 
> big clue, but I don't know what it means.

I don't either.

- Dave



