From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bCWBCBLength is cb length no when
Date: Fri, 5 Dec 2003 13:55:15 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312051351420.645-100000@ida.rowland.org>
References: <1070644705.12411.153.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2308 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264351AbTLESzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2003 13:55:16 -0500
In-Reply-To: <1070644705.12411.153.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

On 5 Dec 2003, Pat LaVarre wrote:

> > Incidentally, Pat, can you confirm whether bInterfaceSubClass x01 = RBC 
> > (Reduced Block Commands, T10 project 1240-D) uses 0-padding of commands to 
> > 12 bytes or not?  The Linux usb-storage driver seems to think that it 
> > doesn't.
> 
> I can neither concisely confirm, nor concisely deny, sorry.
> 
> I cannot conclude confidently either way.

> By a+b+d I say "cdb" for RBC, as for all forms of T10 SPC SCSI over USB.
> 
> By c+e+f+g+h+i I say "plus pad" for RBC, as for all forms of SFF/ T10
> MMC SCSI over USB.
> 
> I feel a+b+d >= c+e+f+g+h+i.  Perhaps only because of my personal
> involvement in b.  Perhaps those sums appear less equally balanced to
> you?

Since usb-storage uses the a+b+d interpretation, that's what I'm inclined 
to go with until more evidence arrives.  But to be safe, it might be best 
to accept commands either with or without padding.


> P.P.S. Once upon a time people here were interested on how impossible it
> is to defeat the sometimes selected Microsoft Outlook default of
> uuencoding mail.  I believe the technique I'm using here now can work on
> any PC, by rebooting via DVD/ CD into Knoppix Linux in place of
> Windows.  Mind you, I'm not completely confident that this e-mail is not
> uuencoded, since by now I have also forgotten the url of the web service
> that bounces a plain text copy of my headers and mail body to me.

I don't know about the original message this postscript came from, but the 
message that came to me was not uuencoded at all.

Alan Stern

