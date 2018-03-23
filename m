From: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/3] Vmbus: Add function to report available ring buffer
 to write in total ring size percentage
Date: Fri, 23 Mar 2018 15:10:18 +0000
Message-ID: <BL0PR2101MB11086A8AD9581CDD7ED08AD8CAA80@BL0PR2101MB1108.namprd21.prod.outlook.com>
References: <20180323001538.31876-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323001538.31876-1-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@linuxonhyperv.com>, KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Long Li <longli@linuxonhyperv.com>
> Sent: Thursday, March 22, 2018 8:16 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> James E . J . Bottomley <JBottomley@odin.com>; Martin K . Petersen
> <martin.petersen@oracle.com>; devel@linuxdriverproject.org; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [PATCH 1/3] Vmbus: Add function to report available ring buffer =
to
> write in total ring size percentage
>=20
> From: Long Li <longli@microsoft.com>
>=20
> Netvsc has a similar function to calculate how much ring buffer in percen=
tage
> is available to write. This function is useful for storvsc and other vmbu=
s devices.
>=20
> Define a similar function in vmbus to be used by storvsc.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> ---

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
