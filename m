From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 8 Jan 2008 10:16:43 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801081013090.2643-100000@iolanthe.rowland.org>
References: <200801081600.52518.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47605 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754075AbYAHPQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 10:16:44 -0500
In-Reply-To: <200801081600.52518.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Tue, 8 Jan 2008, Oliver Neukum wrote:

> Am Montag, 7. Januar 2008 20:42:23 schrieb Alan Stern:
> > This patch applies to 2.6.24-rc6. =A0Comments and suggestions are=20
> > welcome.
>=20
> What about the SG_IO ioctl() ? It seems to me that you must not autos=
uspend
> a device after that ioctl() has been used until the file handle is cl=
osed.

That's an open problem.  The patch does block autosuspends as long as=20
an sg file handle is open, but that won't help with ioctl requests=20
through the block device.

Can you write an additional patch to fix this?

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
