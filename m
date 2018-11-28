From: <Dave.Carroll@microchip.com>
Subject: RE: [PATCH 04/41] scsi: aacraid: linit: Mark expected switch
 fall-through
Date: Wed, 28 Nov 2018 19:24:03 +0000
Message-ID: <BYAPR11MB3447CB719791FC8249AF938B88D10@BYAPR11MB3447.namprd11.prod.outlook.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <d59c13880a70724c3645d96945bf8a128f835244.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d59c13880a70724c3645d96945bf8a128f835244.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: gustavo@embeddedor.com, aacraid@microsemi.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Gustavo A. R. Silva [mailto:gustavo@embeddedor.com]
> Sent: Tuesday, November 27, 2018 9:26 PM
> To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Gustavo A. R. Silva <gustavo@embeddedor.com>
> Subject: [PATCH 04/41] scsi: aacraid: linit: Mark expected switch fall-th=
rough
>=20
>=20
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases wher=
e
> we are expecting to fall through.
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/scsi/aacraid/linit.c | 1 +

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
