From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 11:50:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2C530D.3000903@pacbell.net>
References: <10426732153816@kroah.com> <20030117105414.E359@one-eyed-alien.net>
 <3E2C3380.3070700@splentec.com> <200301201923.50467.oliver@neukum.name>
 <3E2C4678.1090508@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pacbell.net ([67.118.246.66])
 by mta6.snfc21.pbi.net (iPlanet Messaging Server 5.1 HotFix 1.6 (built Oct 18
 2002)) with ESMTP id <0H91005HS2RXX2@mta6.snfc21.pbi.net> for
 linux-scsi@vger.kernel.org; Mon, 20 Jan 2003 11:43:11 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Oliver Neukum <oliver@neukum.name>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:

> But a removal of a device would probably have to start in top-down
> approach, to free/release/etc resources/etc, rather than a bottom-up
> approach (I just cannot see how this would work...)

Well, the driver model core covers key parts of that.  Or it was
at least intended to ... in fact, today I think the bus drivers
(like USB and PCI) need to own the top-down logic for cases like
resume and hub/bridge/adapter (dis)connect.  (And their bottom-up
analogues for suspension.)

> In general, I wasn't really discussing hotplugging, I was basically
> hinting that SCSI Core could use a few more functionalities, and that
> some things need to go away.

There does seem to be some consensus on that point, which is
a good place to start!

- Dave





