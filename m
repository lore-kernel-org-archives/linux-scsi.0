From: David Brownell <david-b@pacbell.net>
Subject: Re: usb-strage not working in the latest kernel 2.4
Date: Tue, 09 Sep 2003 10:18:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F5E0B80.6040401@pacbell.net>
References: <Pine.LNX.4.44L0.0309081523200.665-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtaw6.prodigy.net ([64.164.98.56]:49593 "EHLO mtaw6.prodigy.net")
	by vger.kernel.org with ESMTP id S264251AbTIIR7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2003 13:59:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.0309081523200.665-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Alan Stern wrote:
> On Mon, 8 Sep 2003, David Brownell wrote:
> 

>>When a device stops responding, it's hard to think the
>>problem is anything other than with the device.  (Though
>>I still don't see where the storage class-specific reset
>>gets sent by usb-storage, maybe that'd clean up better.)
> 
> 
> The reset was sent three times.  Twice in response to command aborts and
> once at the express request of the SCSI layer.  You can see it in the
> logs:

OK, I must have missed it when I was scanning for that
control request ... likely because this one's using the
usbcore method, not the usb-storage one I grepped for.

So I'm back to "hard to think the problem is anything
other than with the device".

- Dave



