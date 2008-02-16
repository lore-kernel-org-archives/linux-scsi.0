From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
Date: Sat, 16 Feb 2008 12:16:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802161207160.3828-100000@iolanthe.rowland.org>
References: <47B71372.5050804@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37545 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754294AbYBPRRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2008 12:17:00 -0500
In-Reply-To: <47B71372.5050804@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Buehler <abuehler.kernel@gmail.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Sat, 16 Feb 2008, Andrew Buehler wrote:

> (Note: I consider it blatantly incorrect to send a reply both to a
> mailing list and directly to the address of someone who is subscribed to
> that list unless you have reason to believe that that someone will not
> see the message otherwise, but in this case I am doing so anyway because
> I see no way to avoid it and still make sure all relevant people receive
> the message.)

I (and a lot of other people as well, to judge by the email I receive) 
don't think this is incorrect.  For one thing, it's not always possible 
to tell whether or not the recipient is subscribed to any of the lists.  
For another, getting two copies of a message is no big deal -- more 
irritating (IMO) is getting a rejection message as a result of replying 
to message which was cross-posted to a closed list.  But in each case, 
hitting the "d" key will delete the unwanted message.

In fact, the thing that bothers me the most is when people reply to a 
long email with just a few lines of new text but don't bother to prune 
the long message down to its essential parts.  This forces me to read 
through hundreds of lines containing nothing new or of interest in 
order to obtain a minimal amount of useful information.

> On 2/16/2008 10:20 AM, Alan Stern wrote:

> > To make a long story short, the USB symptoms you describe indicate a
> > problem with interrupt routing.  This could well explain the other
> > difficulties too.  There are various kernel parameters you can try
> > putting on the boot command line to work around it:  acpi=noirq or
> > acpi=off or pci=noacpi or a few others.
> 
> I have now tried all three of these, with no apparent effect; the USB
> drive is still not detected when plugged in after boot. A naive search
> on Google provides no indication of other possible parameters to try;
> the only list I have found of ACPI-related kernel parameters includes no
> others which seem likely to be helpful without more knowledge of the
> specifics of the situation (and the subsystem) than I have.
> 
> What would the next step be?

People on LKML who are more familiar with interrupt routing problems 
might be able to offer more help.  For now, you can try things like 
turning on CONFIG_USB_DEBUG, posting the output from dmesg, posting the 
contents of /proc/interrupts (say before and after a new USB device is 
plugged in).

Assuming that the 2.6.23 kernel works on your computer, you can go the 
extreme route of installing git and doing a bisection to find the first 
patch causing your difficulty.

Alan Stern

