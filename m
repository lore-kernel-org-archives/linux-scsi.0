From: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v4 net-next 0/4] qed*: Advance to FW 8.33.1.0
Date: Wed, 3 Jan 2018 07:32:29 +0000
Message-ID: <CY1PR0701MB1337F7E67D0DE039C488FF39901E0@CY1PR0701MB1337.namprd07.prod.outlook.com>
References: <1514395808-16916-1-git-send-email-Tomer.Tayar@cavium.com>
 <20180102.135836.317444223426222615.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102.135836.317444223426222615.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Tayar, Tomer" <Tomer.Tayar-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> From: Tomer Tayar <Tomer.Tayar-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Date: Wed, 27 Dec 2017 19:30:04 +0200
>=20
> > This series advances all qed* drivers to use firmware 8.33.1.0 which br=
ings
> > new capabilities and initial support of new HW. The changes are mostly =
in
> > qed, and include changes in the FW interface files, as well as updating=
 the
> > FW initialization and debug collection code. The protocol drivers have
> > minor functional changes for this firmware.
> >
> > Patch 1 Rearranges and refactors the FW interface files in preparation =
of
> > the new FW (no functional change).
> > Patch 2 Prepares the code for support of new HW (no functional change).
> > Patch 3 Actual utilization of the new FW.
> > Patch 4 Advances drivers' version.
> >
> > v3->v4:
> > Fix a compilation issue which was reported by krobot (dependency on CRC=
8).
> >
> > v2->v3:
> > Resend the series with a fixed title in the cover letter.
> >
> > v1->v2:
> > - Break the previous single patch into several patches.
> > - Fix compilation issues which were reported by krobot.
>=20
> I'm going to apply this, however....
>=20
> These firmware update changes are rediculously invasive.
>=20
> Backporting patches through these updates will be a giant task if not
> impossible for anyone who tries to do something like this.
>=20
> Who reviewed these changes outside of Cavium to look for clerical
> and typographical errors?  I be nobody did.  I personally scanned
> them for about 20 minutes.
>=20
> Therefore, it is my judgment that the way firmware support updates are
> done in the QED driver is detrimental to it's long term
> maintainability.
>=20
> Thank you.

Hi Dave,
We fully understand the concern regarding the size/depth of these changes,
and the difficulty of getting them reviewed, etc. Hopefully, this is the la=
st time
you will see such massive changes. Future FW upgrades are expected to be fa=
r
lighter in their impact on the code. We also plan to make them more
frequent, which will further reduce the size/invasiveness of each change.
Thanks, and appreciate your time spent on reviewing this.
Ariel

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
