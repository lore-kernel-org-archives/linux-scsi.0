From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: updated 2.6.16 qla2xxx driver doesn't work for qla2342 card
Date: Thu, 20 Apr 2006 16:43:41 -0700
Message-ID: <20060420234341.GL8514@andrew-vasquezs-powerbook-g4-15.local>
References: <7ea3a06a0604200357j4a2bf1bw8be522ed8eb769c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:9523 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932138AbWDTXnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 19:43:41 -0400
Content-Disposition: inline
In-Reply-To: <7ea3a06a0604200357j4a2bf1bw8be522ed8eb769c8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak <vinayak.pane@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 20 Apr 2006, Vinayak wrote:

> I was using 2.6.12-9 kernel for my server .
> My server is having one qla2342 card & one qla2300 card which I used to
> connect to my RAID controller.
> 
> Now, when I upgraded my kernel to 2.6.16 it stopped working.
> I compiled the kernel & qla sources again & again , but no success.
> 
> Actually, it fails where it tries to fetch the firmware imgae from card.
> Exactly, it fails in "qla2x00_request_firmware" ---> request_firmware -->
> _request_firmware ( in firmware_class.c file)
> 
> I enabled the debug levels also. The detailed log is as bellow I have added
> some of my comments too.
> If you have any clues, why this is happening then let me know about it.
> Probably, qla2342 series doesn't complete such request. Because I could see
> that in 2.6.12 the firmware image is hard coded.
> 
> Let me know about the specifications about qla2342 so that I can fix this
> issue & send  you the patch ( I'm interested in fixing up this problem).
> 

the default behaviour of building firmware-loader modules has been
deprecated in favor of having the firmware reside in user-space and
the request_firmware() APIs used by the driver for retrieval.  Here's
the verbaige from the Kconfig file:

http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;h=ff40906c66f9e3c9ed96a55c828d09181a359805;hb=5a7b46b369419493bab4de67b1526e9f76b22a7f;f=drivers/scsi/qla2xxx/Kconfig


an URL is provided to download the blobs.

Regards,
Andrew Vasquez
