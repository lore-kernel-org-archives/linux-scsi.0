From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 18/37] smartpqi: cleanup messages
Date: Wed, 3 May 2017 19:47:06 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1951D400DA@avsrvexchmbx2.microsemi.net>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314966189.13903.16638515102195812930.stgit@brunhilda>
 <1493151084.2628.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0047.outbound.protection.outlook.com ([104.47.42.47]:17551
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932125AbdECTrP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 15:47:15 -0400
In-Reply-To: <1493151084.2628.17.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Bart Van Assche
> Sent: Tuesday, April 25, 2017 3:11 PM
> To: hch@infradead.org; Viswas G <viswas.g@microsemi.com>; Gerry
> Morong <gerry.morong@microsemi.com>; Mahesh Rajashekhara
> <mahesh.rajashekhara@microsemi.com>; POSWALD@suse.com; Scott
> Benesh <scott.benesh@microsemi.com>; Don Brace
> <don.brace@microsemi.com>; Bader Ali - Saleh
> <bader.alisaleh@microsemi.com>; Kevin Barnett
> <kevin.barnett@microsemi.com>; joseph.szczypek@hpe.com; Scott Teel
> <scott.teel@microsemi.com>; jejb@linux.vnet.ibm.com; Justin Lindley
> <justin.lindley@microsemi.com>; John Hall <John.Hall@microsemi.com>
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 18/37] smartpqi: cleanup messages
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Tue, 2017-04-25 at 14:47 -0500, Don Brace wrote:
> >       case CISS_LV_ENCRYPTED_IN_NON_ENCRYPTED_CONTROLLER:
> >               status =3D
> > -                     "Encrypted volume inaccessible - disabled on ctrl=
";
> > +             "Volume encrypted but encryption disabled on controller";
> >               break;
>=20
> This indentation style is confusing. Please don't do this.
>=20
> Thanks,
>=20
> Bart.

Done

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
