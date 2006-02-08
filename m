From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: Re: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t
Date: Wed,  8 Feb 2006 11:16:59 +0100
Message-ID: <IUD5WB$FD60BECFC5D6F5FC6C05445B9285B6E2@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:9754 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932425AbWBHKRv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 05:17:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: hare <hare@suse.de>, hch <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

> On Tue, Feb 07, 2006 at 12:30:55PM +0100, Hannes Reinecke wrote:
> > As in
> >=20
> > void
> > ahd_freeze_simq(struct ahd_softc *ahd)
> > {
> > 	scsi_block_requests(ahd->platform_data->host);
> > }
> >=20
> > ?
>=20
> Yes.
>=20
Does it mean we could simply remove the platform_data->qfrozen
flag/counter ?


---

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
