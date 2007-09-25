From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down
 disk
Date: Tue, 25 Sep 2007 10:13:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709251012210.3909-100000@iolanthe.rowland.org>
References: <200709242200.04278.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53250 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752209AbXIYONl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 10:13:41 -0400
In-Reply-To: <200709242200.04278.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, 24 Sep 2007, Oliver Neukum wrote:

> Am Montag 24 September 2007 schrieb Alan Stern:
> > On Mon, 24 Sep 2007, Oliver Neukum wrote:
> >=20
> > > > subsystem implements its own form of runtime PM support, then y=
ou'll be
> > > > able to use it properly. =A0But until then, there isn't anythin=
g much you
> > > > can do.
> > >=20
> > > Well, we can't simply cut power. Buffers must be flushed and the =
disk
> > > spun down. The suspend() method of the storage driver will have t=
o become
> > > complex.
> >=20
> > That's right, if the device is a real disk. =A0If it's a flash memo=
ry
> > device then of course these issues don't arise. =A0Unfortunately th=
e
> > driver isn't able to tell one from the other; the user will have to
> > do that for us.
>=20
> So those devices which draw most power we don't suspend :-(
> Furthermore for many devices it will take real user intervention to
> determine what is in the enclosure. This isn't very good. I think
> we can do better.

If by "we" you mean the Linux kernel in general, then I agree.  If by
"we" you mean the USB developers, then I disagree.  Help is needed from
the SCSI people.

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
