From: Andre Tomt <andre@tomt.net>
Subject: Re: libata driver update posted
Date: 19 Jul 2003 02:45:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058575500.3407.103.camel@slurv>
References: <3F1711C8.6040207@pobox.com>
	 <Pine.LNX.4.53.0307180924020.19703@hosting.rdsbv.ro>
	 <3F17F28C.9050105@pobox.com>
	 <1058542771.13515.1599.camel@workshop.saharacpt.lan>
	 <20030718154322.GB27152@gtf.org>  <1058574616.1834.24.camel@nosferatu.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.skjellin.no ([80.239.42.67]:38359 "HELO mail.skjellin.no")
	by vger.kernel.org with SMTP id S270447AbTGSA35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 20:29:57 -0400
In-Reply-To: <1058574616.1834.24.camel@nosferatu.lan>
List-Id: linux-scsi@vger.kernel.org
To: azarah@gentoo.org
Cc: Jeff Garzik <jgarzik@pobox.com>, Catalin BOIE <util@deuroconsult.ro>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Vojtech Pavlik <vojtech@suse.cz>

On l?, 2003-07-19 at 02:30, Martin Schlemmer wrote:
> On Fri, 2003-07-18 at 17:43, Jeff Garzik wrote:
>=20
> > > How is performance compared to the default driver for the ICH5 SA=
TA ?
> >=20
> > I haven't done any comparisons because the "default driver" just fl=
at
> > out doesn't work for me.
> >=20
> > However, if performance is lower, then I consider that a bug.
> >=20
>=20
> Question if you do not mind me being a tad lazy - in ZA SCSI is damn
> expensive, so not much experience ... is there something like hdparm =
-t
> to check throughput ?

hdparm -t works on scsi too. and md, and, well, any block device?

:-)

--=20
Cheers,
Andr=E9 Tomt
andre@tomt.net

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
