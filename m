From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 12/37] smartpqi: change functions to inline
Date: Wed, 3 May 2017 19:32:38 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1951D40088@avsrvexchmbx2.microsemi.net>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314962544.13903.85998539939893843.stgit@brunhilda>
 <1493150863.2628.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:47776
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754361AbdECTco (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 15:32:44 -0400
In-Reply-To: <1493150863.2628.14.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Tuesday, April 25, 2017 3:08 PM
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
> Subject: Re: [PATCH 12/37] smartpqi: change functions to inline
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Tue, 2017-04-25 at 14:47 -0500, Don Brace wrote:
> > From: Kevin Barnett <kevin.barnett@hpe.com>
> >
> > Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> > Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> > Signed-off-by: Don Brace <don.brace@microsemi.com>
> > ---
> >  drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> > index 728db8f..523b730 100644
> > --- a/drivers/scsi/smartpqi/smartpqi_init.c
> > +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> > @@ -432,7 +432,7 @@ static struct pqi_io_request *pqi_alloc_io_request(
> >       return io_request;
> >  }
> >
> > -static void pqi_free_io_request(struct pqi_io_request *io_request)
> > +static inline void pqi_free_io_request(struct pqi_io_request *io_reque=
st)
> >  {
> >       atomic_dec(&io_request->refcount);
> >  }
>=20
> A patch description should not only explain what has been changed but als=
o
> why a change has been made. What is the reason that this function has bee=
n
> declared inline? Why do you think that the compiler is not smart enough t=
o
> decide on its own to inline this function?
>=20
> Thanks,
>=20
> Bart.

We could have given a patch description. I'll provide one.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
