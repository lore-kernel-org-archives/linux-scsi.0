From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH v2 22/30] scsi: aacraid: Merge adapter setup with resolve
 luns
Date: Wed, 3 Jan 2018 17:00:57 +0000
Message-ID: <62b6c88e782c46fe8d502f49a8d885cc@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
        <20171227043451.27813-23-RaghavaAditya.Renukunta@microsemi.com>
 <87h8s31crn.fsf@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0045.outbound.protection.outlook.com ([104.47.36.45]:54496
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750864AbeACRBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jan 2018 12:01:21 -0500
In-Reply-To: <87h8s31crn.fsf@suse.cz>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Pajkovsky <npajkovsky@suse.cz>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Scott Benesh <scott.benesh@microsemi.com>, Tom White <tom.white@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Hi Nikola,

> -----Original Message-----
> From: Nikola Pajkovsky [mailto:npajkovsky@suse.cz]
> Sent: Wednesday, January 3, 2018 2:02 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Scott Benesh <scott.benesh@microsemi.com>; Tom
> White <tom.white@microsemi.com>; dl-esc-Aacraid Linux Driver
> <aacraid@microsemi.com>; Guilherme G . Piccoli
> <gpiccoli@linux.vnet.ibm.com>; Bart Van Assche
> <Bart.VanAssche@wdc.com>
> Subject: Re: [PATCH v2 22/30] scsi: aacraid: Merge adapter setup with res=
olve
> luns
>=20
> EXTERNAL EMAIL
>=20
>=20
> Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> writes:
>=20
> > The device hotplug events are processed only after retrieving the updat=
ed
> > lun information from the fw. Does not make sense to keep them separate.
> >
> > Merge both the hotplug handling and safw adapter setup code into single
> > function.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
>=20
> According to subsequent commit
>=20
>   [PATCH v2 23/30] scsi: aacraid: Block concurrent hotplug event handling
>=20
> this commit is racy, because 23/30 adds ->scan_mutex. Shouldn't be these
> commits squashed?

I tried to make the patches as logically distinct as possible, maybe I got =
a bit too ambitious and I expected the patches to go thru as a set so I don=
=92t think it would make any difference. What do you think?=20

Thanks
Raghava Aditya

> --
> Nikola
