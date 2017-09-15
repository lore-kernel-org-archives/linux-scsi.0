From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH RESEND] aacraid: Fix 2T+ drives on SmartIOC-2000
Date: Fri, 15 Sep 2017 23:37:23 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5B8BDE73@avsrvexchmbx1.microsemi.net>
References: <20170915170428.15237-1-david.carroll@microsemi.com>
 <20170915180115.GB24045@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0053.outbound.protection.outlook.com ([104.47.41.53]:4896
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751201AbdIOXh3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 19:37:29 -0400
In-Reply-To: <20170915180115.GB24045@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Brian King <brking@linux.vnet.ibm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

Hi Christoph,

> > +             if ((le32_to_cpu(dresp->status) =3D=3D ST_OK) &&
> > +                     (le32_to_cpu(dresp->mnt[0].vol) !=3D CT_NONE)) {
> > +                     _aac_probe_container2(context, fibptr);
> > +                     return;
>=20
>                 if (dresp->status =3D=3D cpu_to_le32(ST_OK) &&
>                     dresp->mnt[0].vol !=3D cpu_to_le32(CT_NONE)) {
>=20

I've contemplated this all day, and it looked like sematics, but I assume y=
ou were
Indicating that the cpu_to_le32() of a constant is a compiler issue, vs le3=
2_to_cpu() is a=20
runtime issue. If so, thanks! If not could you elaborate ...

Thanks, -Dave
