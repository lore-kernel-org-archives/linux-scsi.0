From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 16:44:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2C97D7.1070406@pacbell.net>
References: <10426732153816@kroah.com> <200301202251.08356.oliver@neukum.name>
 <3E2C7780.2080307@pacbell.net> <200301210000.24705.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pacbell.net ([67.118.246.232])
 by mta5.snfc21.pbi.net (iPlanet Messaging Server 5.1 HotFix 1.6 (built Oct 18
 2002)) with ESMTP id <0H91006GQGD2JS@mta5.snfc21.pbi.net> for
 linux-scsi@vger.kernel.org; Mon, 20 Jan 2003 16:36:41 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:

>>So you were talking past what I said about notifying that highest level,
>>not disagreeing with it.
> 
> 
> I was trying to make the point that callbacks have no place in that process.

If so, you didn't persuade me ...

> It must go bottom to top and that's it.

... because those disconnect() callbacks are exactly how USB and PCI deliver
that notification to the "top" level, and you've already agreed that SCSI
needs to accomodate those models.  So clearly they have at least that much
of a place.


> 	 Refusing to take notice of a device removal is just not an option.
> This is exactly what the current SCSI idea of an API to do bus removal does.

I perceive violent agreement that a change is needed in that area.

But the next step there would seem to be a patch to the SCSI APIs,
unless I mis-understood what Matt was saying about the issue he ran
into when making usb-storage use the enumeration facilities in the
current SCSI mid/low layers.

- Dave


