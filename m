From: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Subject: RE: [PATCH v4] scsi: ufs: Make sysfs attributes writable
Date: Thu, 9 Aug 2018 08:14:23 +0000
Message-ID: <MWHPR04MB1137C131CC355C7303A0AB279A250@MWHPR04MB1137.namprd04.prod.outlook.com>
References: <20180808224454.243790-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180808224454.243790-1-evgreen@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Adrian Hunter <adrian.hunter@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Evan Green <evgreen@chromium.org>
> Sent: Thursday, August 9, 2018 1:45 AM
> To: Vinayak Holikatti <vinholikatti@gmail.com>; James E.J. Bottomley <jej=
b@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; Stanislav Nijnikov <Stanislav.Nijnikov@wdc.=
com>; Adrian Hunter <adrian.hunter@intel.com>; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Bart Van Assche <Bart=
.VanAssche@wdc.com>
> Cc: Evan Green <evgreen@chromium.org>
> Subject: [PATCH v4] scsi: ufs: Make sysfs attributes writable
>=20
> This change makes the UFS controller's sysfs attributes writable, which
> will enable users to provision unprovisioned UFS devices, or
> re-provision unlocked UFS devices.
>=20
> Signed-off-by: Evan Green <evgreen@chromium.org>

Reviewed-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
