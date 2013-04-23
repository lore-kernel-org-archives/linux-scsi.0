From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Tue, 23 Apr 2013 03:39:56 +0300
Message-ID: <20130423003956.GW11427@reaktio.net>
References: <CAOeNLupUgCbNCfs8mOWgu4Xfv2S=Lrjt0Hdi42ijwsS1bSJi4w@mail.gmail.com>
 <20120910161315.GL8912@reaktio.net>
 <20121021124649.GS8912@reaktio.net>
 <CAOeNLurHZPpo8mV3u5cTQ_mZL1buL4LUv1udyhn7fNZYFmOHQg@mail.gmail.com>
 <20121207134643.GA8912@reaktio.net>
 <CAOeNLuroRgZUvFWYTx7yr5ERtEpjiOwQgcy4COCLsm7Z9wWaKw@mail.gmail.com>
 <CAOeNLuqVPQTsBs1eoizHBcEVbGgLrQOQBxqkV38cGwyKS4UTNA@mail.gmail.com>
 <20121219194142.GO8912@reaktio.net>
 <20130423001936.GV11427@reaktio.net>
 <CAOeNLuo+Pti7LfshpOuzDSwWzdtXw0Ouph7ZAoJ9i7CyaUXiAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:45927 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab3DWAj6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Apr 2013 20:39:58 -0400
Content-Disposition: inline
In-Reply-To: <CAOeNLuo+Pti7LfshpOuzDSwWzdtXw0Ouph7ZAoJ9i7CyaUXiAA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rich <rercola@pha.jhu.edu>
Cc: Emmanuel Florac <eflorac@intellique.com>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Apr 22, 2013 at 08:28:58PM -0400, Rich wrote:
>    I'm told that the fix won't actually be in until P17, because it i=
nvolved
>    touching a large number of codepaths, but that it will be in P17.
>

That's unfortunate.. so another 5-6 months.

Thanks for the info!

-- Pasi

>    - Rich
>=20
>    On Mon, Apr 22, 2013 at 8:19 PM, Pasi K=C3=83=E2=82=ACrkk=C3=83=E2=
=82=ACinen <[1]pasik@iki.fi>
>    wrote:
>=20
>      On Wed, Dec 19, 2012 at 09:41:42PM +0200, Pasi K=C3=83=E2=82=ACr=
kk=C3=83=E2=82=ACinen wrote:
>      > On Wed, Dec 19, 2012 at 02:35:02PM -0500, Rich wrote:
>      > > =C3=82  =C3=82 Nope, I'm wrong.
>      >
>      > :(
>      >
>      > > =C3=82  =C3=82 I flashed P15 on a machine, and the same beha=
vior persisted,
>      right up to
>      > > =C3=82  =C3=82 and including the "groups of 3 devices light =
up when I do my
>      own
>      > > =C3=82  =C3=82 smp_write_gpio".
>      > > =C3=82  =C3=82 Whereas if I flash the experimental blob I wa=
s handed by
>      support to try
>      > > =C3=82  =C3=82 and confirm they had resolved the issue, it d=
oes the correct
>      thing.
>      > > =C3=82  =C3=82 I wonder why this change didn't make it into =
P15.
>      >
>      > Hmm.. if you have open contact channel with LSI support please=
 ask
>      them..
>      > it'd be nice to get the fix for wider audience..
>      >
>=20
>      It seems LSI P16 firmware has been released.. in the FW changelo=
g I can
>      see at least this:
>=20
>      "Disable SGPIO Group ID support in Channel NVDATA XML's. This al=
lows the
>      use of manufacturing page 7 or default slot mapping setting for =
direct
>      connected drive slots."
>=20
>      -- Pasi
>=20
>      >
>      > > =C3=82  =C3=82 - Rich
>      > >
>      > > =C3=82  =C3=82 On Wed, Dec 19, 2012 at 2:00 PM, Rich
>      <[1][2]rercola@pha.jhu.edu> wrote:
>      > >
>      > > =C3=82  =C3=82  =C3=82 From the LSI P15 F/W release notes:
>      > > =C3=82  =C3=82  =C3=82 SCGCQ00342805 (DFCT) =C3=83* - SlotSt=
atus updates to SES managed
>      Enclosure may
>      > > =C3=82  =C3=82  =C3=82 update incorrect slots
>      > > =C3=82  =C3=82  =C3=82 "Modified FW to use SES diag page 0Ah=
 mapping only if SMP
>      Discover
>      > > =C3=82  =C3=82  =C3=82 DeviceSlotNum is used for Encl Phy=C3=
=83* Slot enumeration."
>      > > =C3=82  =C3=82  =C3=82 SCGCQ00345867 (DFCT) =C3=83* - Channe=
l NVDATA internal Phy
>      reverse setting for
>      > > =C3=82  =C3=82  =C3=82 9207-4i4e 9207-8i 9217-4i4e=C3=83* 92=
17-8i and 9201-16i
>      > > =C3=82  =C3=82  =C3=82 "ISSUE DESC:=C3=83* Internal PHY orde=
rs are reversed for the
>      channel boards
>      > > =C3=82  =C3=82  =C3=82 above."
>      > > =C3=82  =C3=82  =C3=82 So I would submit this is likely fixe=
d by this FW rev.
>      > > =C3=82  =C3=82  =C3=82 - Rich
>      > >
>      > > =C3=82  =C3=82  =C3=82 On Fri, Dec 7, 2012 at 8:46 AM, Pasi =
K=C3=83*=C3=A2*=C2=ACrkk=C3=83*=C3=A2*=C2=ACinen
>      <[2][3]pasik@iki.fi>
>      > > =C3=82  =C3=82  =C3=82 wrote:
>      > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 On Thu, Nov 01, 2012 at 11:55=
:25AM -0400, Rich wrote:
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > On Sun, Oct 21, 2012 at 8:4=
6 AM, Pasi
>      K=C3=83*=C3=A2*=C2=ACrkk=C3=83*=C3=A2*=C2=ACinen <[3][4]pasik@ik=
i.fi>
>      > > =C3=82  =C3=82  =C3=82  =C3=82 wrote:
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > > On Mon, Sep 10, 2012 at 0=
7:13:15PM +0300, Pasi
>      K=C3=83*=C3=A2*=C2=ACrkk=C3=83*=C3=A2*=C2=ACinen wrote:
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> On Mon, Sep 10, 2012 at =
12:07:45PM -0400, Rich
>      wrote:
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > On Mon, Sep 10, 2012 a=
t 12:04 PM, Pasi
>      K=C3=83*=C3=A2*=C2=ACrkk=C3=83*=C3=A2*=C2=ACinen
>      > > =C3=82  =C3=82  =C3=82  =C3=82 <[4][5]pasik@iki.fi> wrote:
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > > On Mon, Sep 10, 2012=
 at 06:01:42PM +0200,
>      Emmanuel Florac
>      > > =C3=82  =C3=82  =C3=82  =C3=82 wrote:
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> Le Mon, 10 Sep 2012=
 16:47:11 +0300
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> Pasi K=C3=83*=C3=A2=
*=C2=ACrkk=C3=83*=C3=A2*=C2=ACinen <[5][6]pasik@iki.fi>
>      =C3=83*=C3=82=C2=A9crivait:
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >>
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> > Any replies from =
Supermicro/LSI ?
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >>
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> Only loosely relate=
d, but Supermicro replaced
>      recently my
>      > > =C3=82  =C3=82  =C3=82  =C3=82 846E26 (dual
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> expander backplane)=
 with 846E16 (single
>      expander).
>      > > =C3=82  =C3=82  =C3=82  =C3=82 Apparently they
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> gave up getting the=
 E26 to work properly or
>      something: LSI
>      > > =C3=82  =C3=82  =C3=82  =C3=82 expander
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> firmware problem.
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >>
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> In another (very la=
rge scale, high end) setup,
>      many
>      > > =C3=82  =C3=82  =C3=82  =C3=82 different 60 slots
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> 5 LSI expanders cha=
ssis had a general failure
>      of the 5th
>      > > =C3=82  =C3=82  =C3=82  =C3=82 drawer.
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> Another LSI SAS-2 e=
xpander firmware problem.
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >>
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> I could start a ran=
t about the evil of
>      proprietary firmware,
>      > > =C3=82  =C3=82  =C3=82  =C3=82 etc. You
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >> get my meaning :)
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >>
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > > Yeah, this is a good=
 example why we're trying to
>      get the LEDs
>      > > =C3=82  =C3=82  =C3=82  =C3=82 working with
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > > direct attach (non-e=
xpander) backplanes :)
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > > -- Pasi
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > I don't have anything =
useful for people, other
>      than that they
>      > > =C3=82  =C3=82  =C3=82  =C3=82 have
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > shown me an HBA firmwa=
re that fixes the LED
>      problem but has
>      > > =C3=82  =C3=82  =C3=82  =C3=82 other
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > problems they're still=
 debugging.
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> > So there does exist co=
de for this firmware which
>      will fix this
>      > > =C3=82  =C3=82  =C3=82  =C3=82 problem.
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >>
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> That's good to know! Let=
's hope the fix ends up in
>      an official
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >> LSI HBA firmware update =
in not-so-distant future.
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >>
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > > Btw what was the version =
number of the LED-fixed LSI
>      firmware?
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > > I'm just wondering in whi=
ch firmware series the fix
>      might end up
>      > > =C3=82  =C3=82  =C3=82  =C3=82 being included..
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > > Also: Any updates on this=
?
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > > Thanks,
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > > -- Pasi
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > The fixed FW I had demonstr=
ated for me was still
>      14.0.0.0 - I've
>      > > =C3=82  =C3=82  =C3=82  =C3=82 been
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > told it'll be rolled into t=
he FW release currently on
>      the site and
>      > > =C3=82  =C3=82  =C3=82  =C3=82 > posted at some point, but t=
hat they have no ETA for
>      that.
>      > > =C3=82  =C3=82  =C3=82  =C3=82 >
>      > >
>      > > =C3=82  =C3=82  =C3=82  =C3=82 I can now see P15 firmware av=
ailable on LSI's website for
>      9211-8i
>      > > =C3=82  =C3=82  =C3=82  =C3=82 (SAS2008 based HBA).
>      > > =C3=82  =C3=82  =C3=82  =C3=82 Sadly it's missing the releas=
enotes/changelogs for both
>      the LSI bios
>      > > =C3=82  =C3=82  =C3=82  =C3=82 and firmware..
>      > > =C3=82  =C3=82  =C3=82  =C3=82 -- Pasi
>      > >
>      > > References
>      > >
>      > > =C3=82  =C3=82 Visible links
>      > > =C3=82  =C3=82 1. mailto:[7]rercola@pha.jhu.edu
>      > > =C3=82  =C3=82 2. mailto:[8]pasik@iki.fi
>      > > =C3=82  =C3=82 3. mailto:[9]pasik@iki.fi
>      > > =C3=82  =C3=82 4. mailto:[10]pasik@iki.fi
>      > > =C3=82  =C3=82 5. mailto:[11]pasik@iki.fi
>      > --
>      > To unsubscribe from this list: send the line "unsubscribe linu=
x-scsi"
>      in
>      > the body of a message to [12]majordomo@vger.kernel.org
>      > More majordomo info at
>      =C3=82 [13]http://vger.kernel.org/majordomo-info.html
>=20
> References
>=20
>    Visible links
>    1. mailto:pasik@iki.fi
>    2. mailto:rercola@pha.jhu.edu
>    3. mailto:pasik@iki.fi
>    4. mailto:pasik@iki.fi
>    5. mailto:pasik@iki.fi
>    6. mailto:pasik@iki.fi
>    7. mailto:rercola@pha.jhu.edu
>    8. mailto:pasik@iki.fi
>    9. mailto:pasik@iki.fi
>   10. mailto:pasik@iki.fi
>   11. mailto:pasik@iki.fi
>   12. mailto:majordomo@vger.kernel.org
>   13. http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
