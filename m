From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 10:41:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309221038440.2160-100000@home.osdl.org>
References: <20030922102315.A1632@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:32916 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263245AbTIVRme (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 13:42:34 -0400
In-Reply-To: <20030922102315.A1632@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl


On Mon, 22 Sep 2003, Patrick Mansfield wrote:
> On Mon, Sep 22, 2003 at 09:09:47AM -0700, Linus Torvalds wrote:
> > 
> > (Btw, where are the different mode sense pages documented?)
> 
> The latest SCSI 3 draft standards are online as follows, the SCSI 2 specs
> are also online at www.t10.org (.ORG!).
> 
> For block (applies to some USB mass storage) specific pages:
> 
> http://www.t10.org/ftp/t10/drafts/sbc/sbc-r08c.pdf
> 
> See page 105 section 7.1.3 of the above (table 73 the "Mode page codes").

Ok, thanks. In particular, it seems to be pointless to read anything past 
byte 20 - nothing past there is even defined.

What's the general sense of things - for a random SCSI device with bugs 
(and they all have _some_ sort of bugs, let's not just rain on USB here), 
is it saner to try to read just the bytes we need (3 bytes: page code, 
page size and the cache bits), or the full 20 bytes?

		Linus

