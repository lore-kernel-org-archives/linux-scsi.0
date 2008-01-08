From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 8 Jan 2008 14:42:08 +0100
Message-ID: <200801081442.09354.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0801072235110.30331-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:44795 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYAHNls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 08:41:48 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801072235110.30331-100000@netrider.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

Am Dienstag, 8. Januar 2008 04:56:03 schrieb Alan Stern:
> > You'll have to add this method whenever a new subsystem is affected
> > by power management.
>=20
> Sorry, I don't understand your point. =A0If you mean that we'll have =
to
> add autosuspend and autoresume code to every driver that wants to
> support autosuspend, I agree. =A0There doesn't seem to be any way aro=
und
> it. =A0Note that the code added by the companion usb-storage patch is=
=20
> pretty small.

OK, you've convinced me.
But I'd be happier if you put the notification into the generic device =
code.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
