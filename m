From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Fri, 5 Sep 2008 15:35:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809051533280.4482-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0808271447260.17771-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49060 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751167AbYIETfO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2008 15:35:14 -0400
In-Reply-To: <Pine.LNX.4.44L0.0808271447260.17771-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 27 Aug 2008, Alan Stern wrote:

> This patch (as1133) fixes a bug in the interaction between
> scsi_end_request() and scsi_io_completion().  The bug was triggered by
> recent changes to accomodate USB drives can't access their last few
> sectors using multi-sector transfers (the so-called last_sector_bug
> flag).
> 
> The bug shows up when a multi-sector I/O request has been broken up
> into single-sector commands.  If one of those commands gets an error,
> the remainder of the request never gets completed.  This is because
> the "bytes" value passed to scsi_end_request() is completely wrong; it
> is the transfer size of the current command, not the total transfer
> size of the request.

There hasn't been any reply to this patch submission.  For reference,
the original message is at

	http://marc.info/?l=linux-scsi&m=121986305201166&w=2

Has it been accepted, rejected, or did it fall through the cracks?

Alan Stern

