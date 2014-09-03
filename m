From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 3 Sep 2014 16:30:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409031625040.2156-100000@iolanthe.rowland.org>
References: <1409774224.6571.18.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43354 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755858AbaICUa1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 16:30:27 -0400
In-Reply-To: <1409774224.6571.18.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Dale R. Worley" <worley@alum.mit.edu>, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 3 Sep 2014, James Bottomley wrote:

> Before we embark on elaborate hacks, why don't we just make the capacity
> writeable (by root) in sysfs from userspace (will require block change)?
> We can then encode all the nasty heuristics (including gpt reading) in
> userspace as a udev rule.

That's what I'm working on.  Except that I don't know where to do it in
the block layer, so for now I'm adding the attribute to sd.c.

Where in the block layer would the right place be?  We want this to
apply only to entire devices, not to individual partitions.

Alan Stern

