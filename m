From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Sun, 21 Oct 2012 15:46:49 +0300
Message-ID: <20121021124649.GS8912@reaktio.net>
References: <CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
 <20120819102531.GP19851@reaktio.net>
 <5030E0F8.5@gmail.com>
 <20120819131309.GQ19851@reaktio.net>
 <CAOeNLupdpdDqQUhabgQhZjF0rP+XcTV6jF-XhYW3=KUfmW=R4Q@mail.gmail.com>
 <20120910134711.GJ8912@reaktio.net>
 <20120910180142.6adfd3f3@harpe.intellique.com>
 <20120910160407.GK8912@reaktio.net>
 <CAOeNLupUgCbNCfs8mOWgu4Xfv2S=Lrjt0Hdi42ijwsS1bSJi4w@mail.gmail.com>
 <20120910161315.GL8912@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:38005 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab2JUMqw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Oct 2012 08:46:52 -0400
Content-Disposition: inline
In-Reply-To: <20120910161315.GL8912@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rich <rercola@pha.jhu.edu>
Cc: Emmanuel Florac <eflorac@intellique.com>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Sep 10, 2012 at 07:13:15PM +0300, Pasi K=E4rkk=E4inen wrote:
> On Mon, Sep 10, 2012 at 12:07:45PM -0400, Rich wrote:
> > On Mon, Sep 10, 2012 at 12:04 PM, Pasi K=E4rkk=E4inen <pasik@iki.fi=
> wrote:
> > > On Mon, Sep 10, 2012 at 06:01:42PM +0200, Emmanuel Florac wrote:
> > >> Le Mon, 10 Sep 2012 16:47:11 +0300
> > >> Pasi K=E4rkk=E4inen <pasik@iki.fi> =E9crivait:
> > >>
> > >> > Any replies from Supermicro/LSI ?
> > >> >
> > >>
> > >> Only loosely related, but Supermicro replaced recently my 846E26=
 (dual
> > >> expander backplane) with 846E16 (single expander). Apparently th=
ey
> > >> gave up getting the E26 to work properly or something: LSI expan=
der
> > >> firmware problem.
> > >>
> > >> In another (very large scale, high end) setup, many different 60=
 slots
> > >> 5 LSI expanders chassis had a general failure of the 5th drawer.
> > >> Another LSI SAS-2 expander firmware problem.
> > >>
> > >> I could start a rant about the evil of proprietary firmware, etc=
=2E You
> > >> get my meaning :)
> > >>
> > >
> > > Yeah, this is a good example why we're trying to get the LEDs wor=
king with
> > > direct attach (non-expander) backplanes :)
> > >
> > > -- Pasi
> > >
> >=20
> > I don't have anything useful for people, other than that they have
> > shown me an HBA firmware that fixes the LED problem but has other
> > problems they're still debugging.
> >=20
> > So there does exist code for this firmware which will fix this prob=
lem.
> >=20
>=20
> That's good to know! Let's hope the fix ends up in an official=20
> LSI HBA firmware update in not-so-distant future.
>=20

Btw what was the version number of the LED-fixed LSI firmware?
I'm just wondering in which firmware series the fix might end up being =
included..

Also: Any updates on this?

Thanks,

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
