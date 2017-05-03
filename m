From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 16/37] smartpqi: minor driver cleanup
Date: Wed, 3 May 2017 19:43:28 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1951D400BF@avsrvexchmbx2.microsemi.net>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314964963.13903.14012776472974802241.stgit@brunhilda>
 <1493150990.2628.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0066.outbound.protection.outlook.com ([104.47.36.66]:18270
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754650AbdECTnr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 15:43:47 -0400
In-Reply-To: <1493150990.2628.16.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Tuesday, April 25, 2017 3:10 PM
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
> Subject: Re: [PATCH 16/37] smartpqi: minor driver cleanup
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Tue, 2017-04-25 at 14:47 -0500, Don Brace wrote:
> > From: Kevin Barnett <kevin.barnett@hpe.com>
> >
> > - align with in-house driver
>=20
> This is not an appropriate patch description. A patch description should
> explain what has been changed and also what the purpose is of these
> changes.
>=20
> Thanks,
>=20
> Bart.

Agreed, added patch description

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
