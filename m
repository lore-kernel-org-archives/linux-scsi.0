From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 02/37] smartpqi: cleanup interrupt management
Date: Wed, 3 May 2017 15:23:50 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1951D3FD38@avsrvexchmbx2.microsemi.net>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314956402.13903.6707238397795732028.stgit@brunhilda>
 <1493150087.2628.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0042.outbound.protection.outlook.com ([104.47.33.42]:61952
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751944AbdECPYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 11:24:20 -0400
In-Reply-To: <1493150087.2628.7.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Tuesday, April 25, 2017 2:55 PM
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
> Subject: Re: [PATCH 02/37] smartpqi: cleanup interrupt management
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Tue, 2017-04-25 at 14:46 -0500, Don Brace wrote:
> >  static int pqi_request_irqs(struct pqi_ctrl_info *ctrl_info)
> >  {
> > -     struct pci_dev *pdev =3D ctrl_info->pci_dev;
> >       int i;
> >       int rc;
> > +     struct pci_dev *pdev =3D ctrl_info->pci_dev;
>=20
> Was this change necessary? If not, please leave it out.
>=20
> Thanks,
>=20
> Bart.
Done
