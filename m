From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] unsolicited sense in 2.6.0-test5 usb-storage.ko
Date: 10 Sep 2003 16:08:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063231717.6245.22.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101700230.1579-100000@ida.rowland.org>
	 <1063229049.6245.12.camel@patehci2>
	 <20030910145252.F13649@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:62866 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265871AbTIJWHk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 18:07:40 -0400
In-Reply-To: <20030910145252.F13649@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: mdharm-scsi@one-eyed-alien.net
Cc: stern@rowland.harvard.edu, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org


> > > The reason for the unsolicited REQUEST-SENSE ...
> > 
> > Help, lost me.
> > 
> > I'm thinking usb-storage auto sense should
> > always and only follow bCSWStatus = x01
> > Failed.  I'm thinking unsolicited auto sense
> > should occur only if the layers above request
> > such an abuse - never automagically.
> > 
> > I'm thinking not injecting unsolicited auto
> > sense is a part of the unwritten specification
> > that "everyone knows" helps hosts get along
> > with devices.
> > 
> > No?  Where have I gone wrong?
>
> Experience tells us that this is a flawed algorithm.

I don't mean to be stubborn - but I do not understand.

Are you saying we have experience of devices that work Better if we the
host assault them with unsolicited request sense?  Personally I have
precisely the opposite history of pain: I know of Scsi transports that
die if abused with an unsolicited request sense.

I know bInterfaceProtocol = x01 CB pretty much requires unsolicited
request sense.  I mean to be asking about bInterfaceProtocol = x50 BBB.

> > ... I should prepare and forward
> > a patch to correct sgp_dd? ...
> > ...
>
> Yes.

Clear now, thanks, will do.

Pat LaVarre



