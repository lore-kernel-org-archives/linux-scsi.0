From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Wed, 10 Sep 2003 11:46:43 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309101146020.905-100000@ida.rowland.org>
References: <200309100742.QAA15260@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:10756 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265097AbTIJPqo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 11:46:44 -0400
In-Reply-To: <200309100742.QAA15260@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Wed, 10 Sep 2003, Tomita, Haruo wrote:

> Using ioctl (fd, USBDEVFS_RESET, 0), I tested reset. 
> usb-storage of USB2.0 was successful.
> When FDD was used in the case of USB1.1, 
> mount became impossible after reset.

What do you mean?  What does the log show?

Alan Stern

