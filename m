From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 8 Jan 2008 16:30:48 +0100
Message-ID: <200801081630.49376.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0801081013090.2643-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:47424 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbYAHPaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 10:30:17 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801081013090.2643-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

Am Dienstag, 8. Januar 2008 16:16:43 schrieb Alan Stern:
> > What about the SG_IO ioctl() ? It seems to me that you must not aut=
osuspend
> > a device after that ioctl() has been used until the file handle is =
closed.
>=20
> That's an open problem. =A0The patch does block autosuspends as long =
as=20
> an sg file handle is open, but that won't help with ioctl requests=20
> through the block device.
>=20
> Can you write an additional patch to fix this?

I'll work on that.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
