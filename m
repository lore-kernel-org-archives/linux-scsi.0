From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Wed, 27 Feb 2008 15:25:03 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802261113260.4447-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54453 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756775AbYB0UZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 15:25:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 20 Feb 2008, Alan Stern wrote:

> This patch (as1036) causes the SCSI midlayer to take into account the
> residue value provided by some low-level drivers.  There's at least
> one situation (USB mass storage with the Bulk-only transport) where
> the specification states that it is permissible for a device to
> indicate some of the data was not transferred correctly merely by
> setting the residue value, without issuing a Check Condition.

After a week, there hasn't been any feedback on this patch.  Has it
been accepted?  Is there anything wrong with it?  Is it still on a
"to-look-at" queue?

Alan Stern

