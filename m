From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: PS3 Storage Driver O_DIRECT issue
Date: Fri, 13 Jul 2007 15:34:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707131532350.18802@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
	<20070713122752.GA854@aepfle.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-584337861-1147011636-1184333658=:18802"
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <20070713122752.GA854@aepfle.de>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Olaf Hering <olaf@aepfle.de>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J.  Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Alessandro Rubini <rubini@ipvvis.unipv.it>, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1147011636-1184333658=:18802
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jul 2007, Olaf Hering wrote:
> This driver (or the generic PS3 code) has appearently problems with
> O_DIRECT.=20
> glibc aborts parted because the malloc metadata get corrupted. While it
> is reproducible, the place where it crashes changes with every version
> of the debug attempt.
> I dont have a handle right now, all I know is that the metadata after a
> malloc area get overwritten with zeros.
>=20
>=20
> Can you have a look at this?=20
> parted /dev/ps3da
> print (a few times)

I can't seem to reproduce this with parted 1.7.1-5.1 (from Debian
etch/lenny/sid) and kernel 2.6.22-g77320894.

With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
Fax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Belg=
ium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
Fortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE3900138235861=
9
---584337861-1147011636-1184333658=:18802
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev
---584337861-1147011636-1184333658=:18802--
