From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] sd: Fix regression in sd_read_cache_type
Date: Wed, 23 Mar 2011 14:30:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1103231427530.2211-100000@iolanthe.rowland.org>
References: <480032.5780.qm@web31811.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34296 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932562Ab1CWSaF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 14:30:05 -0400
In-Reply-To: <480032.5780.qm@web31811.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Richard Senior <richard@r-senior.demon.co.uk>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 23 Mar 2011, Luben Tuikov wrote:

> --- On Wed, 3/23/11, Alan Stern <stern@rowland.harvard.edu> wrote:
>=20
> > No.=A0 It means I'll submit a new version of the
> > $SUBJECT patch (which in=20
> > fact I have already done),
>=20
> I just saw it and acked it.

Thank you.

> > > If by "fail" you mean "crash", then yes, that's bad.
> > However, the device may return less data. The while loop of
> > my patch, 24d720b726c1a85f1962831ac30ad4d2ef8276b1, will
> > correctly parse the returned
> > > less data.
> >=20
> > True; my patches catch that case.=A0 They prevent a
> > second MODE SENSE=20
> > command from being sent if it would ask for less data than
> > the first=20
> > command has already asked for.
>=20
> By "that" case you mean asking for less data than already asked for. =
You don't mean "parsing the MOSE SENSE data for any len correctly".

Correct.

> Indeed, there is no point in asking for _less_ data than already aske=
d for, as the loop I included in my topic patch, 24d720b726c1a85f196283=
1ac30ad4d2ef8276b1, will parse that data correctly.

Exactly.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
