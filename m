From: Andreas Schwab <schwab@suse.de>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Tue, 24 Jul 2007 14:52:32 +0200
Message-ID: <je3aze6k1b.fsf@sykes.suse.de>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<46A5E610.7000508@shadowen.org> <46A5F275.7060905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXGXMwf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 08:52:35 -0400
In-Reply-To: <46A5F275.7060905@garzik.org> (Jeff Garzik's message of "Tue\, 24
	Jul 2007 08\:37\:09 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Andrew Morton <akpm@linux-foundation.org>

Jeff Garzik <jeff@garzik.org> writes:

> Andy Whitcroft wrote:
>> Andrew Morton wrote:
>>=20
>>>> +	start_sector =3D req->sector*priv->blocking_factor;
>>>> +	sectors =3D req->nr_sectors*priv->blocking_factor;
>>> s/*/ * /.  checkpatch missed this.
>>=20
>> Ok, this is something we need to decide on.  Currently we only ask f=
or
>> consistent spacing on all the mathematic operators.  This is mostly =
as
>> we do see a large number of non-spaced uses in defines and the like.
>>=20
>> I am happy to expand these tests so they are always spaced on both s=
ides
>> style if that is the preference.
>
> That is most definitely the preference:  spaces surround operators.
                                                          ^binary

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
