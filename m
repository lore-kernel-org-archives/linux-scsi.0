From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Sat, 13 Sep 2003 11:14:14 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309131112580.23613-100000@netrider.rowland.org>
References: <200309130651.PAA12009@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:12307 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261182AbTIMPOP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2003 11:14:15 -0400
In-Reply-To: <200309130651.PAA12009@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Sat, 13 Sep 2003, Tomita, Haruo wrote:

> Alan> This makes it look like the device isn't probed again after 
> Alan> usbdevfs does the port reset. 
> 
> Is it that a problem is in a device?

No, it's a problem in Linux.  The port-reset code is not fully developed.

> Alan> Yet another thing to worry about.  But since it's in 2.4, 
> Alan> people probably won't worry about it very hard.
> 
> I think so.
> 
> Thanks!!
> Haruo

Alan Stern

