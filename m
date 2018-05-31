From: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Subject: RE: [PATCH 0/7] Enable UFS provisioning via Linux
Date: Thu, 31 May 2018 10:04:18 +0000
Message-ID: <MWHPR04MB11372C75BFC9416BAF5E81A19A630@MWHPR04MB1137.namprd04.prod.outlook.com>
References: <20180529181740.195362-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Gwendal Grignou <gwendal@chromium.org>, Alex Lemberg <Alex.Lemberg@wdc.com>, Avri Altman <Avri.Altman@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hi Evan,
I have some generic notes:
- Why to create new sysfs entries for the configuration descriptor fields i=
f they are just duplication of fields in the device and unit descriptors? A=
nd the sysfs representation of the device and unit descriptors is existing =
already.
- It would be nice to have some "packet" mode allowing to gather configurat=
ion changes and apply them at once, not one by one.
- Why to put documentation update in the separate patches?

Regards
Stanislav

> -----Original Message-----
> From: Evan Green <evgreen@chromium.org>
> Sent: Tuesday, May 29, 2018 9:18 PM
> To: Vinayak Holikatti <vinholikatti@gmail.com>; James E.J. Bottomley <jej=
b@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; Stanislav Nijnikov <Stanislav.Nijnikov@wdc.=
com>; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Cc: Gwendal Grignou <gwendal@chromium.org>; Evan Green <evgreen@chromium.=
org>
> Subject: [PATCH 0/7] Enable UFS provisioning via Linux
>=20
> This series enables provisioning UFS devices using the existing sysfs
> interface. This functionality is primarily useful along the assembly
> line, but might also be useful for end users that receive devices that
> aren't locked down.
>=20
> Evan Green (7):
>   scsi: ufs: Add Configuration Descriptor to sysfs
>   scsi: ufs: Add config descriptor documentation
>   scsi: ufs: Make sysfs attributes writable
>   scsi: ufs: sysfs: Document attribute writability
>   scsi: ufs: Refactor descriptor read for write
>   scsi: ufs: Enable writing config descriptor
>   scsi: ufs: Update config descriptor documentation
>=20
>  Documentation/ABI/testing/sysfs-driver-ufs | 174 ++++++++++++++++++++---
>  drivers/scsi/ufs/ufs-sysfs.c               | 217 +++++++++++++++++++++++=
+++---
>  drivers/scsi/ufs/ufs.h                     |  29 ++++
>  drivers/scsi/ufs/ufshcd.c                  |  89 ++++++++----
>  drivers/scsi/ufs/ufshcd.h                  |  16 ++-
>  5 files changed, 458 insertions(+), 67 deletions(-)
>=20
> --
> 2.13.5
