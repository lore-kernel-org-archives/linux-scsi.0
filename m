From: Pedro Sousa <PedroM.Sousa@synopsys.com>
Subject: RE: [PATCH] scsi: uapi: ufs: Fix SPDX license identifier
Date: Fri, 28 Jun 2019 11:25:12 +0000
Message-ID: <MN2PR12MB3167D6E742D06055FDCFB17ACCFC0@MN2PR12MB3167.namprd12.prod.outlook.com>
References: <1560346477-13944-1-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1560346477-13944-1-git-send-email-avri.altman@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Pedro Sousa <PedroM.Sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

From: Avri Altman <avri.altman@wdc.com>
Date: Wed, Jun 12, 2019 at 14:34:37

> added 'WITH Linux-syscall-note' exception, which is the officially
> assigned exception identifier for the kernel syscall exception.
> This exception makes it possible to include GPL headers into non GPL
> code, without confusing license compliance tools.
>=20
> fixes: a851b2bd3632 (scsi: uapi: ufs: Make utp_upiu_req visible to user
> 		     space)
>=20
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  include/uapi/scsi/scsi_bsg_ufs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bs=
g_ufs.h
> index 17c7abd..9988db6 100644
> --- a/include/uapi/scsi/scsi_bsg_ufs.h
> +++ b/include/uapi/scsi/scsi_bsg_ufs.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>  /*
>   * UFS Transport SGIO v4 BSG Message Support
>   *
> --=20
> 1.9.1

Hi Avri,

I don't see any issue.=20

Thanks

Reviewed-by: Pedro Sousa <pedrom.sousa@synopsys.com>=20
