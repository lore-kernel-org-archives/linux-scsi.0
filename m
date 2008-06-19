From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Thu, 19 Jun 2008 16:13:25 -0700
Message-ID: <200806191613.25552.david-b@pacbell.net>
References: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:29861 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753153AbYFSXNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2008 19:13:33 -0400
In-Reply-To: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Wilcox <matthew@wil.cx>, Pekka J Enberg <penberg@cs.helsinki.fi>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Thursday 19 June 2008, Alan Stern wrote:
> Maybe a better approach would be to poll at reasonable intervals=20
> (HZ/10, for example) for the existence of the root device. =A0If it=20
> hasn't appeared after some reasonable time (30 seconds?) then give up=
=2E

Why give up, ever?=20

If someone has to walk across the room to grab the device with the
root filesystem, then has to answer the phone, then deal with the
next interruption ... for an hour before getting back to the machine
they rebooted, why shouldn't it just work to plug in the USB flash
drive (CF card, MMC card, or whatever) *THEN* instead of having had
to rush and meet some arbitrarily early deadline?

When there's no root, I don't see how waiting for it to arrive
could be a lose...

- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
