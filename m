From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 06/16] aacraid: Added sysfs for driver version
Date: Thu, 16 Feb 2017 19:38:13 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8C3009@avsrvexchmbx2.microsemi.net>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-7-RaghavaAditya.Renukunta@microsemi.com>
 <30a69431-f904-38f7-7aca-df2ff02cc5d0@suse.de>
 <4D8E82A446BF54499747901DBDEB737A7B8C180D@avsrvexchmbx2.microsemi.net>
 <d51bf566-59c3-1f7a-1998-01f17cb33e85@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0051.outbound.protection.outlook.com ([104.47.42.51]:44285
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932694AbdBPTip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 14:38:45 -0500
In-Reply-To: <d51bf566-59c3-1f7a-1998-01f17cb33e85@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Wednesday, February 15, 2017 11:43 PM
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
> On 02/15/2017 07:12 PM, Raghava Aditya Renukunta wrote:
> >
> > I agree , but it makes it easier to get the driver version when I am
> developing
> > and I don't know which driver version is currently loaded
> >
> > In addition internally our test automation suites use this information =
as
> > opposed to modinfo to get the driver version running.
>=20
> OK then.
>=20
> Speaking of test automation, is there something you may be able to share?
>=20
> Thanks,
>         Johannes

Well still in the very initial phases, so nothing concrete yet.

The plan is to compile the source and install it on various kernels for tes=
ting
 and modinfo  will not be able to retrieve the version info. =20

Additionally it seems to be a  cleaner method when compared to modinfo.

Regards,
Raghava Aditya

> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
