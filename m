From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Wed, 31 Jul 2013 11:13:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1307311105250.1546-100000@iolanthe.rowland.org>
References: <1375270790.17175.10.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36696 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760236Ab3GaPNp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jul 2013 11:13:45 -0400
In-Reply-To: <1375270790.17175.10.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, hare@suse.de

On Wed, 31 Jul 2013, Oliver Neukum wrote:

> These errors should be handled cleanly. How about this patch?

> From 76a377d9894dc8945e9afecc7f9864e6dc3156b1 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oneukum@suse.de>
> Date: Wed, 31 Jul 2013 13:32:51 +0200
> Subject: [PATCH] sd: handle errors during suspend
> 
> Errors during suspend must be handled according to reasons

You forgot to complete this sentence.

> Errors due to missing media or unplugged devices must be ignored.
> The error returns must be modified so that the generic layer
> understands them.

The patch contains a couple of trivial whitespace errors (space added
to the end of a line, or spaces used instead of a tab).

More importantly, if we already know that the medium is not present or
has been changed since it was last used, then there's no reason to call
sd_sync_cache() at all.

Alan Stern

