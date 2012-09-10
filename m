From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Mon, 10 Sep 2012 19:04:07 +0300
Message-ID: <20120910160407.GK8912@reaktio.net>
References: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com>
 <20120818235247.GO19851@reaktio.net>
 <CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
 <20120819102531.GP19851@reaktio.net>
 <5030E0F8.5@gmail.com>
 <20120819131309.GQ19851@reaktio.net>
 <CAOeNLupdpdDqQUhabgQhZjF0rP+XcTV6jF-XhYW3=KUfmW=R4Q@mail.gmail.com>
 <20120910134711.GJ8912@reaktio.net>
 <20120910180142.6adfd3f3@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:53563 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab2IJQEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2012 12:04:11 -0400
Content-Disposition: inline
In-Reply-To: <20120910180142.6adfd3f3@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Rich <rercola@pha.jhu.edu>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Sep 10, 2012 at 06:01:42PM +0200, Emmanuel Florac wrote:
> Le Mon, 10 Sep 2012 16:47:11 +0300
> Pasi K=E4rkk=E4inen <pasik@iki.fi> =E9crivait:
>=20
> > Any replies from Supermicro/LSI ?=20
> >=20
>=20
> Only loosely related, but Supermicro replaced recently my 846E26 (dua=
l
> expander backplane) with 846E16 (single expander). Apparently they
> gave up getting the E26 to work properly or something: LSI expander
> firmware problem.
>=20
> In another (very large scale, high end) setup, many different 60 slot=
s
> 5 LSI expanders chassis had a general failure of the 5th drawer.
> Another LSI SAS-2 expander firmware problem.
>=20
> I could start a rant about the evil of proprietary firmware, etc. You
> get my meaning :)
>=20

Yeah, this is a good example why we're trying to get the LEDs working w=
ith=20
direct attach (non-expander) backplanes :)

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
