From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Mon, 10 Sep 2012 19:13:15 +0300
Message-ID: <20120910161315.GL8912@reaktio.net>
References: <20120818235247.GO19851@reaktio.net>
 <CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
 <20120819102531.GP19851@reaktio.net>
 <5030E0F8.5@gmail.com>
 <20120819131309.GQ19851@reaktio.net>
 <CAOeNLupdpdDqQUhabgQhZjF0rP+XcTV6jF-XhYW3=KUfmW=R4Q@mail.gmail.com>
 <20120910134711.GJ8912@reaktio.net>
 <20120910180142.6adfd3f3@harpe.intellique.com>
 <20120910160407.GK8912@reaktio.net>
 <CAOeNLupUgCbNCfs8mOWgu4Xfv2S=Lrjt0Hdi42ijwsS1bSJi4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:54027 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab2IJQNR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2012 12:13:17 -0400
Content-Disposition: inline
In-Reply-To: <CAOeNLupUgCbNCfs8mOWgu4Xfv2S=Lrjt0Hdi42ijwsS1bSJi4w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rich <rercola@pha.jhu.edu>
Cc: Emmanuel Florac <eflorac@intellique.com>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Sep 10, 2012 at 12:07:45PM -0400, Rich wrote:
> On Mon, Sep 10, 2012 at 12:04 PM, Pasi K=E4rkk=E4inen <pasik@iki.fi> =
wrote:
> > On Mon, Sep 10, 2012 at 06:01:42PM +0200, Emmanuel Florac wrote:
> >> Le Mon, 10 Sep 2012 16:47:11 +0300
> >> Pasi K=E4rkk=E4inen <pasik@iki.fi> =E9crivait:
> >>
> >> > Any replies from Supermicro/LSI ?
> >> >
> >>
> >> Only loosely related, but Supermicro replaced recently my 846E26 (=
dual
> >> expander backplane) with 846E16 (single expander). Apparently they
> >> gave up getting the E26 to work properly or something: LSI expande=
r
> >> firmware problem.
> >>
> >> In another (very large scale, high end) setup, many different 60 s=
lots
> >> 5 LSI expanders chassis had a general failure of the 5th drawer.
> >> Another LSI SAS-2 expander firmware problem.
> >>
> >> I could start a rant about the evil of proprietary firmware, etc. =
You
> >> get my meaning :)
> >>
> >
> > Yeah, this is a good example why we're trying to get the LEDs worki=
ng with
> > direct attach (non-expander) backplanes :)
> >
> > -- Pasi
> >
>=20
> I don't have anything useful for people, other than that they have
> shown me an HBA firmware that fixes the LED problem but has other
> problems they're still debugging.
>=20
> So there does exist code for this firmware which will fix this proble=
m.
>=20

That's good to know! Let's hope the fix ends up in an official=20
LSI HBA firmware update in not-so-distant future.

> [I don't disagree on the evils of proprietary firmware, but this is
> the hand I've been dealt, so.]
>=20

Yeah, there's still the proprietary LSI HBA firmware, but at least usin=
g
direct-attach backplanes has one less :)=20

Thanks!

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
