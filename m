From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [REPOST PATCH v4 0/3] scsi: ufs-bsg: Add read descriptor
Date: Tue, 26 Feb 2019 10:59:11 +0000
Message-ID: <SN6PR04MB4925DC77A8727791B07EA648FC7B0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1550646674-15258-1-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550646674-15258-1-git-send-email-avri.altman@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Avi Shchislowski <Avi.Shchislowski@wdc.com>, Alex Lemberg <Alex.Lemberg@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Evan Green <evgreen@chromium.org>, Bean Huo <beanhuo@micron.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Martin,
Any further comments concerning this series?

Thanks,
Avri

>=20
> UFS Protocol Information Units (UPIU) are UFS packets that travel
> between the host and the device on the UniPro bus. Our previous series
> added the capability to send UPIUs to the ufs driver. It does not cover
> all the possible UPIU types - we are mainly focused on device management,
> provisioning, testing and validation, so it covers UPIUs that falls in
> that box.
>=20
> Our intension is to publish ufs-utils soon - an open source user space
> utility that relies on that infrastructure to perform those tasks.
> This short series is adding one last functionality needed by ufs-utils
> that was somehow left behind - allowing reading descriptors as well.
>=20
> Repost of v4 and adds tags already received.
> While at it, it turns out that quite a few people are waiting for
> ufs-utils, e.g. https://www.spinics.net/lists/linux-scsi/msg127807.html.
> So I expect that the small, but vibrant community of ufs users, will try
> to expand this infrastructure even further.
>=20
> V3->v4:
> Improve code readability in ufs-bsg: Allow reading descriptors
> Update Reviewed-by tag.
>=20
> V2->v3:
> Add a prep patch with write descriptor calling convention changes.
> Elaborate the commit log of ufs-bsg: Allow reading descriptors
> Add Reviewed-by tag.
>=20
> v1->v2:
> Withdraw from the attempt to change the reply buffer, instead place the
> descriptor being read in the actual data buffer in the bio.
>=20
> Avri Altman (3):
>   scsi: ufs-bsg: Change the calling convention for write descriptor
>   scsi: ufs: Allow reading descriptor via raw upiu
>   scsi: ufs-bsg: Allow reading descriptors
>=20
>  Documentation/scsi/ufs.txt | 11 ++++++++
>  drivers/scsi/ufs/ufs_bsg.c | 63 ++++++++++++++++++++++++++--------------=
----
> --
>  drivers/scsi/ufs/ufshcd.c  | 20 ++++++++++-----
>  3 files changed, 61 insertions(+), 33 deletions(-)
>=20
> --
> 1.9.1
