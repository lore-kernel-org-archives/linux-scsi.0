From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Wed, 19 Dec 2012 21:41:42 +0200
Message-ID: <20121219194142.GO8912@reaktio.net>
References: <20120910134711.GJ8912@reaktio.net>
 <20120910180142.6adfd3f3@harpe.intellique.com>
 <20120910160407.GK8912@reaktio.net>
 <CAOeNLupUgCbNCfs8mOWgu4Xfv2S=Lrjt0Hdi42ijwsS1bSJi4w@mail.gmail.com>
 <20120910161315.GL8912@reaktio.net>
 <20121021124649.GS8912@reaktio.net>
 <CAOeNLurHZPpo8mV3u5cTQ_mZL1buL4LUv1udyhn7fNZYFmOHQg@mail.gmail.com>
 <20121207134643.GA8912@reaktio.net>
 <CAOeNLuroRgZUvFWYTx7yr5ERtEpjiOwQgcy4COCLsm7Z9wWaKw@mail.gmail.com>
 <CAOeNLuqVPQTsBs1eoizHBcEVbGgLrQOQBxqkV38cGwyKS4UTNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:40009 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab2LSTlp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Dec 2012 14:41:45 -0500
Content-Disposition: inline
In-Reply-To: <CAOeNLuqVPQTsBs1eoizHBcEVbGgLrQOQBxqkV38cGwyKS4UTNA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rich <rercola@pha.jhu.edu>
Cc: Emmanuel Florac <eflorac@intellique.com>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Dec 19, 2012 at 02:35:02PM -0500, Rich wrote:
>    Nope, I'm wrong.

:(

>    I flashed P15 on a machine, and the same behavior persisted, right=
 up to
>    and including the "groups of 3 devices light up when I do my own
>    smp_write_gpio".
>    Whereas if I flash the experimental blob I was handed by support t=
o try
>    and confirm they had resolved the issue, it does the correct thing=
=2E
>    I wonder why this change didn't make it into P15.

Hmm.. if you have open contact channel with LSI support please ask them=
=2E.=20
it'd be nice to get the fix for wider audience..

Thanks!

-- Pasi

>    - Rich
>=20
>    On Wed, Dec 19, 2012 at 2:00 PM, Rich <[1]rercola@pha.jhu.edu> wro=
te:
>=20
>      From the LSI P15 F/W release notes:
>      SCGCQ00342805 (DFCT) =C3=82 - SlotStatus updates to SES managed =
Enclosure may
>      update incorrect slots
>      "Modified FW to use SES diag page 0Ah mapping only if SMP Discov=
er
>      DeviceSlotNum is used for Encl Phy=C3=82 Slot enumeration."
>      SCGCQ00345867 (DFCT) =C3=82 - Channel NVDATA internal Phy revers=
e setting for
>      9207-4i4e 9207-8i 9217-4i4e=C3=82 9217-8i and 9201-16i
>      "ISSUE DESC:=C3=82 Internal PHY orders are reversed for the chan=
nel boards
>      above."
>      So I would submit this is likely fixed by this FW rev.
>      - Rich
>=20
>      On Fri, Dec 7, 2012 at 8:46 AM, Pasi K=C3=83=E2=82=ACrkk=C3=83=E2=
=82=ACinen <[2]pasik@iki.fi>
>      wrote:
>=20
>        On Thu, Nov 01, 2012 at 11:55:25AM -0400, Rich wrote:
>        > On Sun, Oct 21, 2012 at 8:46 AM, Pasi K=C3=83=E2=82=ACrkk=C3=
=83=E2=82=ACinen <[3]pasik@iki.fi>
>        wrote:
>        > > On Mon, Sep 10, 2012 at 07:13:15PM +0300, Pasi K=C3=83=E2=82=
=ACrkk=C3=83=E2=82=ACinen wrote:
>        > >> On Mon, Sep 10, 2012 at 12:07:45PM -0400, Rich wrote:
>        > >> > On Mon, Sep 10, 2012 at 12:04 PM, Pasi K=C3=83=E2=82=AC=
rkk=C3=83=E2=82=ACinen
>        <[4]pasik@iki.fi> wrote:
>        > >> > > On Mon, Sep 10, 2012 at 06:01:42PM +0200, Emmanuel Fl=
orac
>        wrote:
>        > >> > >> Le Mon, 10 Sep 2012 16:47:11 +0300
>        > >> > >> Pasi K=C3=83=E2=82=ACrkk=C3=83=E2=82=ACinen <[5]pasi=
k@iki.fi> =C3=83=C2=A9crivait:
>        > >> > >>
>        > >> > >> > Any replies from Supermicro/LSI ?
>        > >> > >> >
>        > >> > >>
>        > >> > >> Only loosely related, but Supermicro replaced recent=
ly my
>        846E26 (dual
>        > >> > >> expander backplane) with 846E16 (single expander).
>        Apparently they
>        > >> > >> gave up getting the E26 to work properly or somethin=
g: LSI
>        expander
>        > >> > >> firmware problem.
>        > >> > >>
>        > >> > >> In another (very large scale, high end) setup, many
>        different 60 slots
>        > >> > >> 5 LSI expanders chassis had a general failure of the=
 5th
>        drawer.
>        > >> > >> Another LSI SAS-2 expander firmware problem.
>        > >> > >>
>        > >> > >> I could start a rant about the evil of proprietary f=
irmware,
>        etc. You
>        > >> > >> get my meaning :)
>        > >> > >>
>        > >> > >
>        > >> > > Yeah, this is a good example why we're trying to get =
the LEDs
>        working with
>        > >> > > direct attach (non-expander) backplanes :)
>        > >> > >
>        > >> > > -- Pasi
>        > >> > >
>        > >> >
>        > >> > I don't have anything useful for people, other than tha=
t they
>        have
>        > >> > shown me an HBA firmware that fixes the LED problem but=
 has
>        other
>        > >> > problems they're still debugging.
>        > >> >
>        > >> > So there does exist code for this firmware which will f=
ix this
>        problem.
>        > >> >
>        > >>
>        > >> That's good to know! Let's hope the fix ends up in an off=
icial
>        > >> LSI HBA firmware update in not-so-distant future.
>        > >>
>        > >
>        > > Btw what was the version number of the LED-fixed LSI firmw=
are?
>        > > I'm just wondering in which firmware series the fix might =
end up
>        being included..
>        > >
>        > > Also: Any updates on this?
>        > >
>        > > Thanks,
>        > >
>        > > -- Pasi
>        > >
>        >
>        > The fixed FW I had demonstrated for me was still 14.0.0.0 - =
I've
>        been
>        > told it'll be rolled into the FW release currently on the si=
te and
>        > posted at some point, but that they have no ETA for that.
>        >
>=20
>        I can now see P15 firmware available on LSI's website for 9211=
-8i
>        (SAS2008 based HBA).
>        Sadly it's missing the releasenotes/changelogs for both the LS=
I bios
>        and firmware..
>        -- Pasi
>=20
> References
>=20
>    Visible links
>    1. mailto:rercola@pha.jhu.edu
>    2. mailto:pasik@iki.fi
>    3. mailto:pasik@iki.fi
>    4. mailto:pasik@iki.fi
>    5. mailto:pasik@iki.fi
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
