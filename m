From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 06/16] aacraid: Added sysfs for driver version
Date: Wed, 15 Feb 2017 18:12:56 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8C180D@avsrvexchmbx2.microsemi.net>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-7-RaghavaAditya.Renukunta@microsemi.com>
 <30a69431-f904-38f7-7aca-df2ff02cc5d0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0074.outbound.protection.outlook.com ([104.47.38.74]:14112
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750800AbdBOSNJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 13:13:09 -0500
In-Reply-To: <30a69431-f904-38f7-7aca-df2ff02cc5d0@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Wednesday, February 15, 2017 12:33 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Dave Carroll <david.carroll@microsemi.com>; Gana Sridaran
> <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>; dan.carpenter@oracle.com
> Subject: Re: [PATCH 06/16] aacraid: Added sysfs for driver version
>=20
> EXTERNAL EMAIL
>=20
>=20
> On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> > Added support to retrieve driver version from a new sysfs variable call=
ed
> > driver_version. It makes it easier for the user to figure out the drive=
r
> > version that is currently running.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> > ---
>=20
> Can't this be retrieved via modinfo?

I agree , but it makes it easier to get the driver version when I am develo=
ping
and I don't know which driver version is currently loaded

In addition internally our test automation suites use this information as
opposed to modinfo to get the driver version running.=20

Regards,
Raghava Aditya

> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
