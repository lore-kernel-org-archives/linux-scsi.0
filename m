From: Beraldo Leal <uid0@beraldoleal.org>
Subject: Re: Adaptec 9405w in debian - HELP
Date: Mon, 24 Jul 2006 23:31:36 -0200
Message-ID: <20060725013135.GA29497@beraldoleal.org>
References: <20060723141934.GA12721@beraldoleal.org> <20060724140708.046490ba.akpm@osdl.org> <20060724223017.GA11296@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 200199045101.user.veloxzone.com.br ([200.199.45.101]:33749 "EHLO
	debian.rn.gov.br") by vger.kernel.org with ESMTP id S932405AbWGYCZy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 22:25:54 -0400
Content-Disposition: inline
In-Reply-To: <20060724223017.GA11296@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

This email left me confused, forgives my ignorance, but if I understood
I do not have as or adaptec 9405w SATA to working in debian? But in the
Red Hat? And if I to catch this to driver adp94xx in the place of
aic94xx can work in debian?=20


More one time, forgives for my ignrance.
On Mon, Jul 24, 2006 at 03:30:17PM -0700, Mike Anderson wrote:
> Andrew Morton <akpm@osdl.org> wrote:
> >=20
> > > Hi Andrew, I see your page in wikipedia about the Adaptec 9405w, =
I
> > > follow the steps, but I don't see my SATA disk.
>=20
> The version of the aic94xx driver in James aic94xx-sas-2.6 git tree, =
which
> I assume the patch previously mentioned is derived from, does not con=
tain
> SATA support. Currently it is only supporting SAS.
>=20
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Abra=E7os,
Beraldo Leal
uid0@beraldoleal.org
www.beraldoleal.org

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
