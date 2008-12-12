From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.27 looping on SCSI errors for bad sectors
Date: Fri, 12 Dec 2008 09:46:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812120945580.2504-100000@iolanthe.rowland.org>
References: <200812120005.35034.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44364 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756031AbYLLOqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2008 09:46:42 -0500
In-Reply-To: <200812120005.35034.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Daniel Drake <dsd@gentoo.org>, linux-scsi@vger.kernel.org

On Fri, 12 Dec 2008, Oliver Neukum wrote:

> Am Donnerstag, 11. Dezember 2008 23:02:04 schrieb Alan Stern:
> > 2.6.27 does retry the read, indefinitely as far as I can tell. =A0A=
t
> > least, if there is a means for giving up eventually, I don't know w=
hat
> > it is. =A0My B'' patch provides such a means, but I doubt it will b=
e
> > accepted since it would interfere with the operation of some SCSI t=
ape
> > devices.
>=20
> How so?

I don't know the details.  See

	http://marc.info/?l=3Dlinux-scsi&m=3D122842458004037&w=3D2

and the other messages in that thread.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
