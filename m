From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] usb-storage: implement autosuspend
Date: Mon, 2 Aug 2010 16:36:10 +0200
Message-ID: <201008021636.10290.oneukum@suse.de>
References: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0HBOgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2010 10:36:38 -0400
In-Reply-To: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Am Mittwoch, 28. Juli 2010, 23:12:39 schrieb Alan Stern:
> 
> This patch (as1400) adds runtime-PM support to usb-storage.  It
> utilizes the SCSI layer's runtime-PM implementation, so its scope is
> limited.  Currently the only effect is that disk-like devices (such as
> card readers or flash drives) will be autosuspended if they aren't
> mounted and their device files aren't open.  This would apply, for
> example, to card readers that don't contain a memory card.

So it will autosuspend devices that do contain a medium, which
is not mounted? This is a bit problematic, as some card readers
will report a medium change upon resumption?

How does user space deal with this?

	Regards
		Oliver
