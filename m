From: Kallol Biswas <nucleodyne@comcast.net>
Subject: Re: How to generate ILI condtion on a tape device
Date: 24 Nov 2003 23:58:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069747131.10749.0.camel@driver>
References: <1069489007.3775.15.camel@driver>
	 <3FC1C1F1.13720A16@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:5276 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262098AbTKYIAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 03:00:13 -0500
In-Reply-To: <3FC1C1F1.13720A16@fujitsu-siemens.com>
List-Id: linux-scsi@vger.kernel.org
To: Josef =?ISO-8859-1?Q?M=F6llers?= <josef.moellers@fujitsu-siemens.com>
Cc: scsi <linux-scsi@vger.kernel.org>

Thank you. I already have tested the code path with dd command.

On Mon, 2003-11-24 at 00:31, Josef M=C3=B6llers wrote:
> > Kallol Biswas wrote:
> >=20
> > Hi,
> >   I was wondering how to generate ILI condition while reading from =
a
> > tape.
>=20
> IIRC all you need is a tape with variable block size and you just rea=
d
> the wrong blocksize.
>=20
>=20
> Josef
--=20
Kallol Biswas <nucleodyne@comcast.net>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
