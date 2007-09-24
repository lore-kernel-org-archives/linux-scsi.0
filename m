From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Mon, 24 Sep 2007 22:00:03 +0200
Message-ID: <200709242200.04278.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709241532380.5920-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:36517 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbXIXT7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 15:59:12 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709241532380.5920-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Montag 24 September 2007 schrieb Alan Stern:
> On Mon, 24 Sep 2007, Oliver Neukum wrote:
>=20
> > > subsystem implements its own form of runtime PM support, then you=
'll be
> > > able to use it properly. =A0But until then, there isn't anything =
much you
> > > can do.
> >=20
> > Well, we can't simply cut power. Buffers must be flushed and the di=
sk
> > spun down. The suspend() method of the storage driver will have to =
become
> > complex.
>=20
> That's right, if the device is a real disk. =A0If it's a flash memory
> device then of course these issues don't arise. =A0Unfortunately the
> driver isn't able to tell one from the other; the user will have to
> do that for us.

So those devices which draw most power we don't suspend :-(
=46urthermore for many devices it will take real user intervention to
determine what is in the enclosure. This isn't very good. I think
we can do better.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
