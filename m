From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Mon, 2 Sep 2013 17:44:35 +0300
Message-ID: <20130902144435.GG2924@reaktio.net>
References: <CAOeNLurHZPpo8mV3u5cTQ_mZL1buL4LUv1udyhn7fNZYFmOHQg@mail.gmail.com>
 <20121207134643.GA8912@reaktio.net>
 <CAOeNLuroRgZUvFWYTx7yr5ERtEpjiOwQgcy4COCLsm7Z9wWaKw@mail.gmail.com>
 <CAOeNLuqVPQTsBs1eoizHBcEVbGgLrQOQBxqkV38cGwyKS4UTNA@mail.gmail.com>
 <20121219194142.GO8912@reaktio.net>
 <20130423001936.GV11427@reaktio.net>
 <CAOeNLuo+Pti7LfshpOuzDSwWzdtXw0Ouph7ZAoJ9i7CyaUXiAA@mail.gmail.com>
 <20130423003956.GW11427@reaktio.net>
 <CAOeNLuqnX9r-jrmq0kV1=kU3XOzFEttDQktcD5338BzaBX3KHg@mail.gmail.com>
 <20130901171302.GF2924@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:40174 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab3IBOoi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 10:44:38 -0400
Content-Disposition: inline
In-Reply-To: <20130901171302.GF2924@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rich <rercola@pha.jhu.edu>
Cc: Emmanuel Florac <eflorac@intellique.com>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Sep 01, 2013 at 08:13:02PM +0300, Pasi K=E4rkk=E4inen wrote:
> On Fri, Aug 30, 2013 at 05:38:04PM -0400, Rich wrote:
> >    Apparently, only about 4 months.
> >    P17 firmware is out.
> >    Tested on a card which was demonstrating the incorrect behavior =
before, of
> >    model 9201-16i.
> >    It does appear to contain the fixes for this problem.
>=20
> This is great news, finally!=20
> Thanks for testing and reporting!
>

Hmm, I checked the P17 firmware changelog PDFs for LSI 9211-8i, 9207-8i=
 and 9201-16i,
and I can't see anything about this issue being fixed..=20

But if you say it's now fixed, then I guess it means LSI doesn't list e=
very change in the changelog..

-- Pasi
=20
>=20
> >    - Rich
> >=20
> >    On Mon, Apr 22, 2013 at 8:39 PM, Pasi K=E4rkk=E4inen <[1]pasik@i=
ki.fi> wrote:
> >=20
> >      On Mon, Apr 22, 2013 at 08:28:58PM -0400, Rich wrote:
> >      >    I'm told that the fix won't actually be in until P17, bec=
ause it
> >      involved
> >      >    touching a large number of codepaths, but that it will be=
 in P17.
> >      >
> >=20
> >      That's unfortunate.. so another 5-6 months.
> >=20
> >      Thanks for the info!
> >=20
> >      -- Pasi
> >=20
> >      >    - Rich
> >      >
> >      >    On Mon, Apr 22, 2013 at 8:19 PM, Pasi K=C3*rkk=C3*inen
> >      <[1][2]pasik@iki.fi>
> >      >    wrote:
> >      >
> >      >      On Wed, Dec 19, 2012 at 09:41:42PM +0200, Pasi K=C3*rkk=
=C3*inen
> >      wrote:
> >      >      > On Wed, Dec 19, 2012 at 02:35:02PM -0500, Rich wrote:
> >      >      > > =C2  =C2 Nope, I'm wrong.
> >      >      >
> >      >      > :(
> >      >      >
> >      >      > > =C2  =C2 I flashed P15 on a machine, and the same b=
ehavior
> >      persisted,
> >      >      right up to
> >      >      > > =C2  =C2 and including the "groups of 3 devices lig=
ht up when I
> >      do my
> >      >      own
> >      >      > > =C2  =C2 smp_write_gpio".
> >      >      > > =C2  =C2 Whereas if I flash the experimental blob I=
 was handed by
> >      >      support to try
> >      >      > > =C2  =C2 and confirm they had resolved the issue, i=
t does the
> >      correct
> >      >      thing.
> >      >      > > =C2  =C2 I wonder why this change didn't make it in=
to P15.
> >      >      >
> >      >      > Hmm.. if you have open contact channel with LSI suppo=
rt please
> >      ask
> >      >      them..
> >      >      > it'd be nice to get the fix for wider audience..
> >      >      >
> >      >
> >      >      It seems LSI P16 firmware has been released.. in the FW=
 changelog
> >      I can
> >      >      see at least this:
> >      >
> >      >      "Disable SGPIO Group ID support in Channel NVDATA XML's=
=2E This
> >      allows the
> >      >      use of manufacturing page 7 or default slot mapping set=
ting for
> >      direct
> >      >      connected drive slots."
> >      >
> >      >      -- Pasi
> >      >
> >      >      >
> >      >      > > =C2  =C2 - Rich
> >      >      > >
> >      >      > > =C2  =C2 On Wed, Dec 19, 2012 at 2:00 PM, Rich
> >      >      <[1][2][3]rercola@pha.jhu.edu> wrote:
> >      >      > >
> >      >      > > =C2  =C2  =C2 From the LSI P15 F/W release notes:
> >      >      > > =C2  =C2  =C2 SCGCQ00342805 (DFCT) =C3* - SlotStatu=
s updates to SES
> >      managed
> >      >      Enclosure may
> >      >      > > =C2  =C2  =C2 update incorrect slots
> >      >      > > =C2  =C2  =C2 "Modified FW to use SES diag page 0Ah=
 mapping only if
> >      SMP
> >      >      Discover
> >      >      > > =C2  =C2  =C2 DeviceSlotNum is used for Encl Phy=C3=
* Slot
> >      enumeration."
> >      >      > > =C2  =C2  =C2 SCGCQ00345867 (DFCT) =C3* - Channel N=
VDATA internal Phy
> >      >      reverse setting for
> >      >      > > =C2  =C2  =C2 9207-4i4e 9207-8i 9217-4i4e=C3* 9217-=
8i and 9201-16i
> >      >      > > =C2  =C2  =C2 "ISSUE DESC:=C3* Internal PHY orders =
are reversed for
> >      the
> >      >      channel boards
> >      >      > > =C2  =C2  =C2 above."
> >      >      > > =C2  =C2  =C2 So I would submit this is likely fixe=
d by this FW
> >      rev.
> >      >      > > =C2  =C2  =C2 - Rich
> >      >      > >
> >      >      > > =C2  =C2  =C2 On Fri, Dec 7, 2012 at 8:46 AM, Pasi
> >      K=C3*=E2*=ACrkk=C3*=E2*=ACinen
> >      >      <[2][3][4]pasik@iki.fi>
> >      >      > > =C2  =C2  =C2 wrote:
> >      >      > >
> >      >      > > =C2  =C2  =C2  =C2 On Thu, Nov 01, 2012 at 11:55:25=
AM -0400, Rich
> >      wrote:
> >      >      > > =C2  =C2  =C2  =C2 > On Sun, Oct 21, 2012 at 8:46 A=
M, Pasi
> >      >      K=C3*=E2*=ACrkk=C3*=E2*=ACinen <[3][4][5]pasik@iki.fi>
> >      >      > > =C2  =C2  =C2  =C2 wrote:
> >      >      > > =C2  =C2  =C2  =C2 > > On Mon, Sep 10, 2012 at 07:1=
3:15PM +0300, Pasi
> >      >      K=C3*=E2*=ACrkk=C3*=E2*=ACinen wrote:
> >      >      > > =C2  =C2  =C2  =C2 > >> On Mon, Sep 10, 2012 at 12:=
07:45PM -0400,
> >      Rich
> >      >      wrote:
> >      >      > > =C2  =C2  =C2  =C2 > >> > On Mon, Sep 10, 2012 at 1=
2:04 PM, Pasi
> >      >      K=C3*=E2*=ACrkk=C3*=E2*=ACinen
> >      >      > > =C2  =C2  =C2  =C2 <[4][5][6]pasik@iki.fi> wrote:
> >      >      > > =C2  =C2  =C2  =C2 > >> > > On Mon, Sep 10, 2012 at=
 06:01:42PM +0200,
> >      >      Emmanuel Florac
> >      >      > > =C2  =C2  =C2  =C2 wrote:
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> Le Mon, 10 Sep 2012 16=
:47:11 +0300
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> Pasi K=C3*=E2*=ACrkk=C3=
*=E2*=ACinen
> >      <[5][6][7]pasik@iki.fi>
> >      >      =C3*=C2=A9crivait:
> >      >      > > =C2  =C2  =C2  =C2 > >> > >>
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> > Any replies from Sup=
ermicro/LSI ?
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> >
> >      >      > > =C2  =C2  =C2  =C2 > >> > >>
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> Only loosely related, =
but Supermicro
> >      replaced
> >      >      recently my
> >      >      > > =C2  =C2  =C2  =C2 846E26 (dual
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> expander backplane) wi=
th 846E16 (single
> >      >      expander).
> >      >      > > =C2  =C2  =C2  =C2 Apparently they
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> gave up getting the E2=
6 to work properly
> >      or
> >      >      something: LSI
> >      >      > > =C2  =C2  =C2  =C2 expander
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> firmware problem.
> >      >      > > =C2  =C2  =C2  =C2 > >> > >>
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> In another (very large=
 scale, high end)
> >      setup,
> >      >      many
> >      >      > > =C2  =C2  =C2  =C2 different 60 slots
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> 5 LSI expanders chassi=
s had a general
> >      failure
> >      >      of the 5th
> >      >      > > =C2  =C2  =C2  =C2 drawer.
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> Another LSI SAS-2 expa=
nder firmware
> >      problem.
> >      >      > > =C2  =C2  =C2  =C2 > >> > >>
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> I could start a rant a=
bout the evil of
> >      >      proprietary firmware,
> >      >      > > =C2  =C2  =C2  =C2 etc. You
> >      >      > > =C2  =C2  =C2  =C2 > >> > >> get my meaning :)
> >      >      > > =C2  =C2  =C2  =C2 > >> > >>
> >      >      > > =C2  =C2  =C2  =C2 > >> > >
> >      >      > > =C2  =C2  =C2  =C2 > >> > > Yeah, this is a good ex=
ample why we're
> >      trying to
> >      >      get the LEDs
> >      >      > > =C2  =C2  =C2  =C2 working with
> >      >      > > =C2  =C2  =C2  =C2 > >> > > direct attach (non-expa=
nder) backplanes
> >      :)
> >      >      > > =C2  =C2  =C2  =C2 > >> > >
> >      >      > > =C2  =C2  =C2  =C2 > >> > > -- Pasi
> >      >      > > =C2  =C2  =C2  =C2 > >> > >
> >      >      > > =C2  =C2  =C2  =C2 > >> >
> >      >      > > =C2  =C2  =C2  =C2 > >> > I don't have anything use=
ful for people,
> >      other
> >      >      than that they
> >      >      > > =C2  =C2  =C2  =C2 have
> >      >      > > =C2  =C2  =C2  =C2 > >> > shown me an HBA firmware =
that fixes the LED
> >      >      problem but has
> >      >      > > =C2  =C2  =C2  =C2 other
> >      >      > > =C2  =C2  =C2  =C2 > >> > problems they're still de=
bugging.
> >      >      > > =C2  =C2  =C2  =C2 > >> >
> >      >      > > =C2  =C2  =C2  =C2 > >> > So there does exist code =
for this firmware
> >      which
> >      >      will fix this
> >      >      > > =C2  =C2  =C2  =C2 problem.
> >      >      > > =C2  =C2  =C2  =C2 > >> >
> >      >      > > =C2  =C2  =C2  =C2 > >>
> >      >      > > =C2  =C2  =C2  =C2 > >> That's good to know! Let's =
hope the fix ends
> >      up in
> >      >      an official
> >      >      > > =C2  =C2  =C2  =C2 > >> LSI HBA firmware update in =
not-so-distant
> >      future.
> >      >      > > =C2  =C2  =C2  =C2 > >>
> >      >      > > =C2  =C2  =C2  =C2 > >
> >      >      > > =C2  =C2  =C2  =C2 > > Btw what was the version num=
ber of the
> >      LED-fixed LSI
> >      >      firmware?
> >      >      > > =C2  =C2  =C2  =C2 > > I'm just wondering in which =
firmware series
> >      the fix
> >      >      might end up
> >      >      > > =C2  =C2  =C2  =C2 being included..
> >      >      > > =C2  =C2  =C2  =C2 > >
> >      >      > > =C2  =C2  =C2  =C2 > > Also: Any updates on this?
> >      >      > > =C2  =C2  =C2  =C2 > >
> >      >      > > =C2  =C2  =C2  =C2 > > Thanks,
> >      >      > > =C2  =C2  =C2  =C2 > >
> >      >      > > =C2  =C2  =C2  =C2 > > -- Pasi
> >      >      > > =C2  =C2  =C2  =C2 > >
> >      >      > > =C2  =C2  =C2  =C2 >
> >      >      > > =C2  =C2  =C2  =C2 > The fixed FW I had demonstrate=
d for me was still
> >      >      14.0.0.0 - I've
> >      >      > > =C2  =C2  =C2  =C2 been
> >      >      > > =C2  =C2  =C2  =C2 > told it'll be rolled into the =
=46W release
> >      currently on
> >      >      the site and
> >      >      > > =C2  =C2  =C2  =C2 > posted at some point, but that=
 they have no ETA
> >      for
> >      >      that.
> >      >      > > =C2  =C2  =C2  =C2 >
> >      >      > >
> >      >      > > =C2  =C2  =C2  =C2 I can now see P15 firmware avail=
able on LSI's
> >      website for
> >      >      9211-8i
> >      >      > > =C2  =C2  =C2  =C2 (SAS2008 based HBA).
> >      >      > > =C2  =C2  =C2  =C2 Sadly it's missing the releaseno=
tes/changelogs for
> >      both
> >      >      the LSI bios
> >      >      > > =C2  =C2  =C2  =C2 and firmware..
> >      >      > > =C2  =C2  =C2  =C2 -- Pasi
> >      >      > >
> >      >      > > References
> >      >      > >
> >      >      > > =C2  =C2 Visible links
> >      >      > > =C2  =C2 1. mailto:[7][8]rercola@pha.jhu.edu
> >      >      > > =C2  =C2 2. mailto:[8][9]pasik@iki.fi
> >      >      > > =C2  =C2 3. mailto:[9][10]pasik@iki.fi
> >      >      > > =C2  =C2 4. mailto:[10][11]pasik@iki.fi
> >      >      > > =C2  =C2 5. mailto:[11][12]pasik@iki.fi
> >      >      > --
> >      >      > To unsubscribe from this list: send the line "unsubsc=
ribe
> >      linux-scsi"
> >      >      in
> >      >      > the body of a message to [12][13]majordomo@vger.kerne=
l.org
> >      >      > More majordomo info at
> >      >      =C2 [13][14]http://vger.kernel.org/majordomo-info.html
> >      >
> >      > References
> >      >
> >      >    Visible links
> >      >    1. mailto:[15]pasik@iki.fi
> >      >    2. mailto:[16]rercola@pha.jhu.edu
> >      >    3. mailto:[17]pasik@iki.fi
> >      >    4. mailto:[18]pasik@iki.fi
> >      >    5. mailto:[19]pasik@iki.fi
> >      >    6. mailto:[20]pasik@iki.fi
> >      >    7. mailto:[21]rercola@pha.jhu.edu
> >      >    8. mailto:[22]pasik@iki.fi
> >      >    9. mailto:[23]pasik@iki.fi
> >      >   10. mailto:[24]pasik@iki.fi
> >      >   11. mailto:[25]pasik@iki.fi
> >      >   12. mailto:[26]majordomo@vger.kernel.org
> >      >   13. [27]http://vger.kernel.org/majordomo-info.html
> >=20
> > References
> >=20
> >    Visible links
> >    1. mailto:pasik@iki.fi
> >    2. mailto:pasik@iki.fi
> >    3. mailto:rercola@pha.jhu.edu
> >    4. mailto:pasik@iki.fi
> >    5. mailto:pasik@iki.fi
> >    6. mailto:pasik@iki.fi
> >    7. mailto:pasik@iki.fi
> >    8. mailto:rercola@pha.jhu.edu
> >    9. mailto:pasik@iki.fi
> >   10. mailto:pasik@iki.fi
> >   11. mailto:pasik@iki.fi
> >   12. mailto:pasik@iki.fi
> >   13. mailto:majordomo@vger.kernel.org
> >   14. http://vger.kernel.org/majordomo-info.html
> >   15. mailto:pasik@iki.fi
> >   16. mailto:rercola@pha.jhu.edu
> >   17. mailto:pasik@iki.fi
> >   18. mailto:pasik@iki.fi
> >   19. mailto:pasik@iki.fi
> >   20. mailto:pasik@iki.fi
> >   21. mailto:rercola@pha.jhu.edu
> >   22. mailto:pasik@iki.fi
> >   23. mailto:pasik@iki.fi
> >   24. mailto:pasik@iki.fi
> >   25. mailto:pasik@iki.fi
> >   26. mailto:majordomo@vger.kernel.org
> >   27. http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
