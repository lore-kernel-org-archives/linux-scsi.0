From: Stephen Hemminger <sthemmin@microsoft.com>
Subject: RE: [Resend Patch 1/3] Vmbus: Add function to report available ring
 buffer to write in total ring size percentage
Date: Wed, 28 Mar 2018 23:22:53 +0000
Message-ID: <DM5PR2101MB0917BA3BDBA187201A15F3D8CCA30@DM5PR2101MB0917.namprd21.prod.outlook.com>
References: <20180328004840.22787-1-longli@linuxonhyperv.com>
 <yq1y3ibhndg.fsf@oracle.com>
 <MWHPR2101MB072958DDC25845615C3B1ADCCEA30@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB072958DDC25845615C3B1ADCCEA30@MWHPR2101MB0729.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Long Li <longli@linuxonhyperv.com>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Maybe best through greg's char-misc tree since it has generic hv code and s=
ometime updates both network and scsi.

Alternatively,  put common code through one tree, and hold off the network =
device change till next release.

-----Original Message-----
From: Long Li=20
Sent: Wednesday, March 28, 2018 3:43 PM
To: Martin K. Petersen <martin.petersen@oracle.com>; Long Li <longli@linuxo=
nhyperv.com>
Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.co=
m>; Stephen Hemminger <sthemmin@microsoft.com>; James E . J . Bottomley <JB=
ottomley@odin.com>; devel@linuxdriverproject.org; linux-scsi@vger.kernel.or=
g; linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: RE: [Resend Patch 1/3] Vmbus: Add function to report available rin=
g buffer to write in total ring size percentage

> Subject: Re: [Resend Patch 1/3] Vmbus: Add function to report available r=
ing
> buffer to write in total ring size percentage
>=20
>=20
> Long,
>=20
> > Netvsc has a function to calculate how much ring buffer in percentage
> > is available to write. This function is also useful for storvsc and
> > other vmbus devices.
>=20
> What is the submission strategy for this series? Do you expect it to go
> through net or scsi? If the latter, I'll need an ack from davem.

Martin,

I hope this patch set goes through SCSI, because it's purpose is to improve=
 storvsc.

If this strategy is not possible, I can resubmit the 1st two patches to net=
, and the 3rd patch to scsi after the 1st two are merged.

Long

>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
