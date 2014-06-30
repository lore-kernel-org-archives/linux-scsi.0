From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb-storage/SCSI: Add broken_fua blacklist flag
Date: Mon, 30 Jun 2014 11:16:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1406301115010.1550-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406301100300.1550-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40768 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751927AbaF3PQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2014 11:16:52 -0400
In-Reply-To: <Pine.LNX.4.44L0.1406301100300.1550-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Bryn M. Reeves" <bmr@redhat.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Mon, 30 Jun 2014, Alan Stern wrote:

> Some buggy JMicron USB-ATA bridges don't know how to translate the FU=
A
> bit in READs or WRITEs.  This patch adds an entry in unusual_devs.h
> and a blacklist flag to tell the sd driver not to use FUA.
>=20
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Michael B=C3=BCsch <m@bues.ch>
> Tested-by: Michael B=C3=BCsch <m@bues.ch>
> Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
> CC: <stable@vger.kernel.org>

Greg:

I forgot to add your name to the recipient list on this patch.  Since
James has already Ack'ed it, would you like to take it for your USB
tree?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
