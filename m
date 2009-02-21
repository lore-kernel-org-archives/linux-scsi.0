From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG - MODE SENSE residue miscount in g_file_storage bulk-only
 transport ?
Date: Sat, 21 Feb 2009 15:55:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0902211552510.10689-100000@netrider.rowland.org>
References: <200902211211.39386.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1778 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750889AbZBUUz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2009 15:55:56 -0500
In-Reply-To: <200902211211.39386.david-b@pacbell.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 21 Feb 2009, David Brownell wrote:

> On Monday 16 February 2009, Stanislaw Gruszka wrote:
> >=20
> > > The problem is in the Atmel hardware; it's not capable of halting=
 a
> > > bulk endpoint correctly. =A0You need to invoke g_file_storage wit=
h the
> > > "stall=3Dno" parameter.
> >=20
> > I see, it works now, thanks very much.
>=20
> Should the driver maybe
>=20
> 	if (gadget_is_at91(g))
> 		disable stalls;
>=20
> then?

Perhaps it should.  I have not tried to keep track of which peripheral
drivers are incapable of halting bulk endpoints correctly.  There's
already a similar test for gadget_is_sh(); maybe others should be added
too.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
