From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 0/3] scsi: aacraid: Multi controller Kdump IOP reset
 handling
Date: Wed, 7 Feb 2018 15:52:29 +0000
Message-ID: <5a96031c8f56452380d8badc3f8c95b1@microsemi.com>
References: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
 <yq1vaf93b0k.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0072.outbound.protection.outlook.com ([104.47.33.72]:21536
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754377AbeBGPwf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 10:52:35 -0500
In-Reply-To: <yq1vaf93b0k.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Scott Benesh <scott.benesh@microsemi.com>, Tom White <tom.white@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Tuesday, February 6, 2018 4:21 PM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Scott Benesh <scott.benesh@microsemi.com>; Tom
> White <tom.white@microsemi.com>; dl-esc-Aacraid Linux Driver
> <aacraid@microsemi.com>; Guilherme G . Piccoli
> <gpiccoli@linux.vnet.ibm.com>; Bart Van Assche
> <Bart.VanAssche@wdc.com>
> Subject: Re: [PATCH 0/3] scsi: aacraid: Multi controller Kdump IOP reset
> handling
>=20
> EXTERNAL EMAIL
>=20
>=20
> Raghava,
>=20
> > During Kdump aacraid controller IOP reset is invoked, IOP reset
> > takes approx 40 seconds to bring the controller back up and running.
> > with timeout of 120 seconds and anything more than 2 controllers
> > will cause kdump to timeout.
> >
> > This patchset implements a new reset mechanism called DropIO, that
> > induces the fw to drop any pending IO in the fw and making the reset
> > process quicker.
>=20
> This series doesn't apply to my impending 4.17/scsi-queue. Since the
> latter won't exist until Linus releases rc1, please respin against
> current linus/master and resubmit.

Will do Martin.

Thanks,
Raghava Aditya

> Thanks!
> --
> Martin K. Petersen      Oracle Linux Engineering
