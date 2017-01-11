From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Wed, 11 Jan 2017 10:10:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1701111008530.1900-100000@iolanthe.rowland.org>
References: <20170111133643.GB31565@pali>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57032 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1758763AbdAKPKZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 10:10:25 -0500
In-Reply-To: <20170111133643.GB31565@pali>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Dainius =?utf-8?Q?Masili=C5=ABnas?= <pastas4@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

On Wed, 11 Jan 2017, Pali Rohár wrote:

> On Tuesday 10 January 2017 15:29:23 Alan Stern wrote:
> > > Tom Yan wrote that smartctl/hdparm "works" because they use the SCSI ATA
> > > PASSTHROUGH command. It is not an option for kernel?
> > 
> > No, because many devices do not implement SCSI ATA PASSTHROUGH.  
> > (Consider devices whose underlying technology does not use ATA or SATA,
> > for example.)  And some of the ones that don't implement it will die if
> > you try to send them an ATA PASSTHROUGH command.
> 
> It is not possible to detect if underlaying device is ATA?

I don't know any reliable way to do it.  Besides, even if the device is
ATA, you're still out of luck if the USB-SATA bridge doesn't support
ATA PASSTHROUGH.

> > You have to understand that consumer USB storage really is very
> > low quality in many cases.  Vendors aim for low cost rather than high 
> > reliability or correctness.
> 
> Understood. But lot of distributions call hdparm for inserted disks and
> also set some APM (or at least check it)... That means there is already
> some way how to deal with these problems (in userspace).

Maybe.  Or maybe users simply don't use hdparm if it causes problems 
for them.  You don't have a similar option with the kernel.

Alan Stern

