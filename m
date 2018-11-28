From: <Dave.Carroll@microchip.com>
Subject: RE: [PATCH 03/41] scsi: aacraid: aachba: Mark expected switch
 fall-throughs
Date: Wed, 28 Nov 2018 19:21:56 +0000
Message-ID: <BYAPR11MB3447D45FA7EF566F4C80DDFD88D10@BYAPR11MB3447.namprd11.prod.outlook.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <fba277107d0b94bdd6e7cabf1d17e0fb0b6e13d8.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fba277107d0b94bdd6e7cabf1d17e0fb0b6e13d8.1543374820.git.gustavo@embeddedor.com>
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
> Subject: [PATCH 03/41] scsi: aacraid: aachba: Mark expected switch fall-
> throughs
>=20
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases wher=
e
> we are expecting to fall through.
>=20
> Also, a break statement is properly aligned.
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
