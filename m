From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 14:26:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2C7780.2080307@pacbell.net>
References: <10426732153816@kroah.com> <200301202148.23210.oliver@neukum.name>
 <3E2C68F8.7080405@pacbell.net> <200301202251.08356.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pacbell.net ([67.118.247.72])
 by mta6.snfc21.pbi.net (iPlanet Messaging Server 5.1 HotFix 1.6 (built Oct 18
 2002)) with ESMTP id <0H91002MZ9Z3J8@mta6.snfc21.pbi.net> for
 linux-scsi@vger.kernel.org; Mon, 20 Jan 2003 14:18:42 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
> I should be more specific.

Yes...


> The SCSI is different for several reasons:
> - we are talking about bus as well as device detection
> - there's no common way to probe for devices
>   (the probing of LUNs works only on conventional busses)

So the SCSI stack needs to support more than one model for
device/bus detection.  This can't be news.  And some of them
have to handle "conventional" busses, like USB and PCI; maybe
even handle booting off them...


> - many SCSI devices are not really SCSI devices. They just use
>   the command set
> 
> SCSI hotplug detection doesn't work for the same reason that USB
> can handle only detection of devices by itself. Busses on the other
> hand are not handled by USB itself.

Just how is it that USB doesn't handle USB?  "B" == "Bus" ... :)

If you mean that HCs hook up to a different bus (often PCI), with its
own hotplug support, that doesn't seem so different from SCSI HBAs
hooking up to such busses (often PCI) and cascading the same hotplug
support...


>>Erm ... which of the three SCSI layers are you talking about?  I was
>>talking about the highest level,..
> 
> 
> In SCSI view device and bus disconnection is recognised by the lowest
> level. As it knows nothing about the high layers, it notifies the midlayer

So you were talking past what I said about notifying that highest level,
not disagreeing with it.



