From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH] scsi: aacraid: avoid open-coded upper_32_bits
Date: Tue, 7 Feb 2017 19:37:54 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8B7234@avsrvexchmbx2.microsemi.net>
References: <20170207125948.490095-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170207125948.490095-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Dave Carroll <david.carroll@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, February 7, 2017 5:00 AM
> To: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>; James E.J.
> Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; Johannes Thumshirn
> <jthumshirn@suse.de>; Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; Dave Carroll
> <david.carroll@microsemi.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] scsi: aacraid: avoid open-coded upper_32_bits
>=20
> EXTERNAL EMAIL
>=20
>=20
> Shifting a dma_addr_t right by 32 bits causes a compile-time warning when
> that type is only 32 bit wide:
>=20
> drivers/scsi/aacraid/src.c: In function 'aac_src_start_adapter':
> drivers/scsi/aacraid/src.c:414:29: error: right shift count >=3D width of=
 type [-
> Werror=3Dshift-count-overflow]
>=20
> This changes the driver to use the predefined macros consistently, includ=
ing
> one correct but open-coded upper_32_bits() instance.
>=20
> Fixes: d1ef4da8487f ("scsi: aacraid: added support for init_struct_8")
> Fixes: 423400e64d37 ("scsi: aacraid: Include HBA direct interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Reviewed-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.co=
m>
