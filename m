From: Alan Stern <stern@rowland.harvard.edu>
Subject: ANNOUNCE: Windows XP USB Mass Storage traces available
Date: Wed, 4 Feb 2004 16:50:07 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0402041637310.613-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:7684 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266638AbUBDVuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2004 16:50:07 -0500
List-Id: linux-scsi@vger.kernel.org
To: USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

A series of USB Mass Storage traces for Windows XP is available at

	http://www.win.tue.nl/~aeb/linux/usb/traces/winxp/

These data sets all use the Bulk-only transport, together with protocol 
x06 (Transparent SCSI) or x05 (SFF-8070).  There are variants with 
removable and non-removable media, but all are for Disk-type devices.

Similar traces for other versions of Windows are also available in the
parent directory.

Note that Windows XP does issue MODE SENSE commands for page x08 and page
x3f.  This indicates that Linux ought to be able to use the same commands
when communicating with a Bulk-Only device, provided we Talk Like Windows
and always ask for 192 bytes.  With luck this will provide a general
solution to what has been the trickiest problem for the usb-storage
driver.  (However I can't rule out the possibility that some vendors may
supply specialized Windows drivers for their devices that omit these
commands.)

Thanks to Andries Brouwer for providing space on his web server.

Alan Stern

