From: David Brownell <david-b@pacbell.net>
Subject: Re: A different look at block device hotswap in the Linux kernel
Date: Thu, 23 Jan 2003 23:53:11 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E30F0E7.1040707@pacbell.net>
References: <20030123162034.K95542-100000@wonky.in0.lcl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pacbell.net ([67.118.247.147])
 by mta6.snfc21.pbi.net (iPlanet Messaging Server 5.1 HotFix 1.6 (built Oct 18
 2002)) with ESMTP id <0H9700M7TKC3ZB@mta6.snfc21.pbi.net> for
 linux-scsi@vger.kernel.org; Thu, 23 Jan 2003 23:48:06 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: Oliver Neukum <oliver@neukum.name>, Steven Dake <sdake@mvista.com>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Matthew Jacob wrote:
>>I want:
>>LLDD to SCSI: device is gone
>>SCSI to LLDD: Ok. I'll handle from here on.
>>LLDD: OK. I am gone. And won't have any contact until the next device is
>>plugged in.
>>
>>...
> 
> 
> Could this time limit be fixed (or parameterized) known to all LLDDs?
> This would allow one to try and avoid flooding SCSI with detach/reattach
> events for the 'same' device.

And what exactly is the "same" device?  And who's keeping history
about devices that have previously been attached?  And, says the guy
who's full of questions, didn't Linus want to get rid of such history?

- Dave




