From: <Don.Brace@microchip.com>
Subject: RE: [PATCH 15/41] scsi: hpsa: mark expected switch fall-throughs
Date: Wed, 28 Nov 2018 15:14:45 +0000
Message-ID: <BYAPR11MB2855A40D2B3D808AF09B89CBE1D10@BYAPR11MB2855.namprd11.prod.outlook.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <991ec154d1a1da019442e4fd025a39fa2ad2bebb.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <991ec154d1a1da019442e4fd025a39fa2ad2bebb.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: gustavo@embeddedor.com, don.brace@microsemi.com, esc.storagedev@microsemi.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Gustavo A. R. Silva [mailto:gustavo@embeddedor.com]=20
Sent: Tuesday, November 27, 2018 10:29 PM
To: Don Brace <don.brace@microsemi.com>; esc.storagedev@microsemi.com
Cc: James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen <martin.p=
etersen@oracle.com>; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.o=
rg; Gustavo A. R. Silva <gustavo@embeddedor.com>
Subject: [PATCH 15/41] scsi: hpsa: mark expected switch fall-throughs

EXTERNAL EMAIL


In preparation to enabling -Wimplicit-fallthrough, mark switch cases where =
we are expecting to fall through.

Addresses-Coverity-ID: 1195463 ("Missing break in switch")
Addresses-Coverity-ID: 1195464 ("Missing break in switch")
Addresses-Coverity-ID: 1195465 ("Missing break in switch")
Addresses-Coverity-ID: 1195466 ("Missing break in switch")
Addresses-Coverity-ID: 1357338 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Don Brace <don.brace@microsemi.com>
