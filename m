From: Fabien Salvi <fabien@cri74.org>
Subject: Re: i/o errors
Date: Wed, 23 Jun 2004 16:00:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D98D10.4090205@cri74.org>
References: <200406231142.56957.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:35213 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S265135AbUFWOAt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 10:00:49 -0400
In-Reply-To: <200406231142.56957.bernd-schubert@web.de>
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd-schubert@web.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Bernd Schubert a =E9crit :
> Hello,

Hello,

> we have trouble with our transtec 5008 IDE/SCSI raid array, sometimes=
 the=20
> scsi-driver reports i/o erros. Due to the reason described below, I'm=
 not so=20
> sure if those i/o errors are really caused by the raid-array. So I wa=
nt to=20
> ask if the linux scsi-system might cause/report wrong errors?
>=20
> Description:

 > [...]

> Also, trantec told me that the raid array should report an error to i=
ts logs=20
> when an i/o error happens, but there is no error message at all :(
>=20
>=20
> All those problems happend with 2.4.26, but we now also tried to use =
2.6.7 and=20
> the problem doesn't occur with this kernel. Unfortunality we never re=
ach the=20
> resync speed of >45 MB, its usually about 30MB/s. If we reduced the=20
> resync-speed in 2.4.26 to those values, we also never had the problem=
, so the=20
> test with 2.6.7 doesn't help so much in this case.
>=20
>=20
> So, does someone  here has an idea if this a bug of the transtec arra=
y or of=20
> the linux-scsi system?

I won't be surprised if it's a hardware related problem.
Do you know which is the real manufacturer of the RAID controller and=20
firmware ? I don't think Transtec make their own system...

IMHO, you should try big bench without DRDB using I/O benchmark tool an=
d=20
also simply dd to make big parallel transfers and check if you can=20
reproduce the bug. It would be interested, if you get the bug, to try=20
with other linux kernel revision and also other OS...

Good luck!

--=20
=46abien SALVI
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
