From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Thu, 11 Sep 2003 10:39:45 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309111038210.841-100000@ida.rowland.org>
References: <200309110507.OAA06907@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5124 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261288AbTIKOjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 10:39:48 -0400
In-Reply-To: <200309110507.OAA06907@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Thu, 11 Sep 2003, Tomita, Haruo wrote:

> Hi Alan,
> 
> Haruo> Using ioctl (fd, USBDEVFS_RESET, 0), I tested reset. 
> Haruo> usb-storage of USB2.0 was successful.
> Haruo> When FDD was used in the case of USB1.1, 
> Haruo> mount became impossible after reset.
>  
> Alan> What do you mean?  What does the log show?
> 
> I'm sorry. I wrote the following programs.
> The execution result is as follows.

What did the system log show?  Try turning on verbose usb debugging and 
run your test again.  This time post a copy of the system log.

Alan Stern

