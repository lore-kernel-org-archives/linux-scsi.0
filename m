From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Sat, 30 Aug 2014 17:15:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408301710120.4299-100000@netrider.rowland.org>
References: <CAA6KcBCnns-nuE4LA4EqWGhEbisueBNwAjN7vtYcfBdKm2WyUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:46187 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752601AbaH3VPr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Aug 2014 17:15:47 -0400
In-Reply-To: <CAA6KcBCnns-nuE4LA4EqWGhEbisueBNwAjN7vtYcfBdKm2WyUA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: "Dale R. Worley" <worley@alum.mit.edu>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On Fri, 29 Aug 2014, Matthew Dharm wrote:

> Is there an 'easy' way to override the detected size of a storage
> device from userspace?  If we had that, someone could write a helper
> application which looked for this particular fubar and try to Do The
> Right Thing(tm), or at least offer the user some options.

You mean, force a Media Change event and override the capacity reported 
by the hardware?  I'm not aware of any API for doing that, although it 
probably wouldn't be too hard to add one.

How would the user know what value to put in for the capacity?  Unless 
the drive had been hooked up to a different computer and the user 
manually noted the correct capacity and typed it in, it would have to 
be guesswork.

Alan Stern

