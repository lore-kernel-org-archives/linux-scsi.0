From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.24: NULL scatter-gather pointer in
 usb_storage:usb_stor_access_xfer_buf?
Date: Thu, 31 Jan 2008 11:45:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801311143180.3970-100000@iolanthe.rowland.org>
References: <47A1E6A0.8050500@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45015 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757826AbYAaQpi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 11:45:38 -0500
In-Reply-To: <47A1E6A0.8050500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mark Glines <mark@glines.org>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 31 Jan 2008, Boaz Harrosh wrote:

> >> Please check the below patch.
> >>
> >> one thing that I can see is that the isd200 does an INQUARY transfer
> >> of sizeof(struct inquiry_data) which is 96 bytes, when scsi_scan.c
> >> sends an INQUARY with 36 bytes buffer. So we have an underflow in 
> >> usb_stor_access_xfer_buf().

Maybe the isd200 routine should be changed also, so that it doesn't try
to store too much data in the buffer.

> I will send a proper patch to scsi maintainer. Alan is it OK to send this
> patch threw James's scsi-misc?

You should send patches to Matt Dharm, since he is the usb-storage 
maintainer.

Alan Stern

