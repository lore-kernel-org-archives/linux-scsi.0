From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
Date: Tue, 8 Jul 2008 10:38:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807081036560.2135-100000@iolanthe.rowland.org>
References: <14494.84.245.32.19.1215527306.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57408 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753525AbYGHOjA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 10:39:00 -0400
In-Reply-To: <14494.84.245.32.19.1215527306.squirrel@secure.samage.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Indan Zupancic <indan@nul.nu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Tue, 8 Jul 2008, Indan Zupancic wrote:

> It's not something silly like the device saying it only needs 100mA
> while in reality it needs 200mA? Or are those numbers only used to
> calculate how many devices may be connected?

If it's plugged directly into the computer then it should receive all 
the power it needs.  Unless there's an option to give it more power 
(like a second USB connector with only the power lines attached)?

> > It might work better at full speed than at high speed (although you
> > probably don't want to use it in a degraded mode).
> 
> I have ehci built-in, how can I force full speed? Hm, in the BIOS maybe.

	echo 5 >/sys/class/usb_host/usb_host1/companion

Alan Stern

