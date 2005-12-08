From: Alan Stern <stern@rowland.harvard.edu>
Subject: Write-protect checks
Date: Thu, 8 Dec 2005 13:22:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0512081319420.4934-100000@iolanthe.rowland.org>
References: <1134064043.17102.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55519 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932216AbVLHSWR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 13:22:17 -0500
In-Reply-To: <1134064043.17102.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Antipov <antipov@ru.mvista.com>

On Thu, 8 Dec 2005, Alan Cox wrote:

> On Iau, 2005-12-08 at 11:00 -0500, Alan Stern wrote:
> > module parameter.  For some reason (don't ask me why -- I don't know) the
> > SCSI core doesn't check a disk device's write-protect status unless the
> > device is marked as removable.
> 
> Have you asked the scsi maintainers why this occurs. Having had a quick
> look over the specs I have here I can't see why this is done either.

No, I haven't.

Okay guys.  Does anyone know why sd.c calls sd_read_write_protect_flag 
only for devices with removable media?

Alan Stern

