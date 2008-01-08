From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 8 Jan 2008 10:06:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801081004400.2643-100000@iolanthe.rowland.org>
References: <200801081442.09354.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40225 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754881AbYAHPGy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 10:06:54 -0500
In-Reply-To: <200801081442.09354.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Tue, 8 Jan 2008, Oliver Neukum wrote:

> Am Dienstag, 8. Januar 2008 04:56:03 schrieb Alan Stern:
> > > You'll have to add this method whenever a new subsystem is affect=
ed
> > > by power management.
> >=20
> > Sorry, I don't understand your point. =A0If you mean that we'll hav=
e to
> > add autosuspend and autoresume code to every driver that wants to
> > support autosuspend, I agree. =A0There doesn't seem to be any way a=
round
> > it. =A0Note that the code added by the companion usb-storage patch =
is=20
> > pretty small.
>=20
> OK, you've convinced me.
> But I'd be happier if you put the notification into the generic devic=
e code.

Eventually parts of the autosuspend mechanism will go there.  But first
I thought we should have a proof-of-concept version working for at
least two different subsystems (such as SCSI and USB), so that we can
understand what should go into the generic layer and what should stay
out.

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
