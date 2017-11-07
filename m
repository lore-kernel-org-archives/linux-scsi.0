From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] storvsc: Avoid excessive host scan on controller change
Date: Tue, 7 Nov 2017 07:22:52 +0000
Message-ID: <MWHPR21MB0846B712CA11989D339AD437CE510@MWHPR21MB0846.namprd21.prod.outlook.com>
References: <20171031215808.11629-1-longli@exchange.microsoft.com>
 <yq1o9oe3gf5.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1o9oe3gf5.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Monday, November 6, 2017 7:40 PM
> To: Long Li <longli@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; James E . J . Bottomley
> <JBottomley@odin.com>; Martin K . Petersen
> <martin.petersen@oracle.com>; devel@linuxdriverproject.org; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: Re: [PATCH] storvsc: Avoid excessive host scan on controller cha=
nge
>=20
>=20
> Long,
>=20
> > When there are multiple disks attached to the same SCSI controller,
> > the host may send several VSTOR_OPERATION_REMOVE_DEVICE or
> > VSTOR_OPERATION_ENUMERATE_BUS messages in a row, to indicate
> there is
> > a change on the SCSI controller. In response, storvsc rescans the SCSI
> > host.
>=20
> Applied to 4.15/scsi-queue with some fuzz. Please verify, thanks!

Martin, thank you! All looking good.

Long

>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
