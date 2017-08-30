From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 3/3] scsi: aacraid: report -ENOMEM to upper layer from
 aac_convert_sgraw2()
Date: Wed, 30 Aug 2017 02:10:55 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A8D0C199E@avsrvexchmbx1.microsemi.net>
References: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
 <29ed79bb97060429247eeafc9d6d8f6793a7f6b5.1504007944.git.npajkovsky@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <29ed79bb97060429247eeafc9d6d8f6793a7f6b5.1504007944.git.npajkovsky@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nikola Pajkovsky <npajkovsky@suse.cz>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Nikola Pajkovsky [mailto:npajkovsky@suse.cz]
> Sent: Tuesday, August 29, 2017 4:59 AM
> To: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>
> Cc: Nikola Pajkovsky <npajkovsky@suse.cz>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 3/3] scsi: aacraid: report -ENOMEM to upper layer from
> aac_convert_sgraw2()
>=20
> EXTERNAL EMAIL
>=20
>=20
> aac_convert_sgraw2() kmalloc memory and return -1 on error, which
> should be -ENOMEM. However, nobody is checking return value, so with
> this change, -ENOMEM is propagated to upper layer.
>=20
> Signed-off-by: Nikola Pajkovsky <npajkovsky@suse.cz>
> ---
 [.....]
Reviewed-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.co=
m>
