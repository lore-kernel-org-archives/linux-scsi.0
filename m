From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Mon, 8 Nov 2004 17:08:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0411081707140.22296-100000@ida.rowland.org>
References: <20041108220431.GB17305@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:24324 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261266AbUKHWIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2004 17:08:41 -0500
In-Reply-To: <20041108220431.GB17305@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Mon, 8 Nov 2004, Matthew Dharm wrote:

> Send the SCSI parts to James, I think.  Once they're in, we'll put in the
> USB parts.
> 
> After this patch, are there any other users of usb_stor_access_xfer_buf()?

Loads of 'em.  Just do a grep and you'll see.

Alan Stern

