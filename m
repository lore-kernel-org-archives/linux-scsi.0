From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 2/3] scsi: aacraid: get rid of one level of indentation
Date: Wed, 30 Aug 2017 02:10:35 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A8D0C198B@avsrvexchmbx1.microsemi.net>
References: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
 <bc42b0e33f50825a6227c49459f253557d862b24.1504007944.git.npajkovsky@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bc42b0e33f50825a6227c49459f253557d862b24.1504007944.git.npajkovsky@suse.cz>
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
> Subject: [PATCH 2/3] scsi: aacraid: get rid of one level of indentation
>=20
> EXTERNAL EMAIL
>=20
>=20
>   unsigned long byte_count =3D 0;
>   nseg =3D scsi_dma_map(scsicmd);
>   if (nseg < 0)
>      return nseg;
>   if (nseg) {
>      ...
>   }
>   return byte_count;
>=20
> is equal to
>=20
>   unsigned long byte_count =3D 0;
>   nseg =3D scsi_dma_map(scsicmd);
>   if (nseg <=3D 0)
>      return nseg;
>   ...
>   return byte_count;
>=20
> No other code has changed.
>=20
> Signed-off-by: Nikola Pajkovsky <npajkovsky@suse.cz>
> ---
[.....]
Reviewed-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.co=
m>
