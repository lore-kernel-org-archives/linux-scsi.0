From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH RESEND] aacraid: Fix 2T+ drives on SmartIOC-2000
Date: Sun, 17 Sep 2017 01:23:35 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5B8C4355@avsrvexchmbx2.microsemi.net>
References: <20170915170428.15237-1-david.carroll@microsemi.com>
        <20170915180115.GB24045@infradead.org>
        <423FD6710FB8FB4F8728F93591889F9A5B8BDE73@avsrvexchmbx1.microsemi.net>
 <yq1d16rtpmd.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1d16rtpmd.fsf@oracle.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Brian King <brking@linux.vnet.ibm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Dave,
>=20
> > Hi Christoph,
> >
> >> > +             if ((le32_to_cpu(dresp->status) =3D=3D ST_OK) &&
> >> > +                     (le32_to_cpu(dresp->mnt[0].vol) !=3D CT_NONE))=
 {
> >> > +                     _aac_probe_container2(context, fibptr);
> >> > +                     return;
> >>
> >>                 if (dresp->status =3D=3D cpu_to_le32(ST_OK) &&
> >>                     dresp->mnt[0].vol !=3D cpu_to_le32(CT_NONE)) {
> >>
> >
> > I've contemplated this all day, and it looked like sematics, but I
> > assume you were Indicating that the cpu_to_le32() of a constant is a
> > compiler issue, vs le32_to_cpu() is a runtime issue. If so, thanks! If
> > not could you elaborate ...
>=20
> FWIW, I applied your patch as-is for consistency with the rest of the dri=
ver. I do
> prefer Christoph's version, though, but that can be a follow-on patch.
>=20

Hi Martin,

If I'm right regarding Christph's intentions, and you seem to imply, which =
since I've been an LE person most of my life,  I will instill in my develop=
ment team, and propose another patch to fix that ...

Thanks, -Dave
