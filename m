From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: adding flag for 192 byte mode sense
Date: Tue, 16 Mar 2004 15:08:16 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0403161505060.5945-100000@ida.rowland.org>
References: <20040316180238.GA19787@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6660 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261611AbUCPUIS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 15:08:18 -0500
In-Reply-To: <20040316180238.GA19787@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Tue, 16 Mar 2004, Matthew Dharm wrote:

> Do we know what non-disk type devices use for MODE_SENSE?  That would
> (primarily) be CD-ROMs, I think...

With my USB CDRW drive, Windows 2000 issued x5a = MODE SENSE(10).  It did
so even though the class/protocol/subclass are 08/50/06.  Furthermore,
testing with usb-storage showed that the drive doesn't accept MODE
SENSE(6).

Alan Stern

