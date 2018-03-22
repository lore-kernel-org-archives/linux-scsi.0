From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V3 0/1] scsi: ufs: Add support for Auto-Hibernate Idle Timer
Date: Wed, 21 Mar 2018 21:24:11 -0400
Message-ID: <yq1zi30q4w4.fsf@oracle.com>
References: <1521551258-4027-1-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521551258-4027-1-git-send-email-adrian.hunter@intel.com>
        (Adrian Hunter's message of "Tue, 20 Mar 2018 15:07:37 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Alim Akhtar <alim.akhtar@samsung.com>, Alex Lemberg <Alex.Lemberg@sandisk.com>, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org


Adrian,

> Here is V3, now re-based on top of patch "scsi: ufs: sysfs:reworking of t=
he
> rpm_lvl and spm_lvl entries".
>
> Micha=C5=82 Potomski has previously sent a patch for Auto-Hibernate, but =
this
> patch is slightly different, based on the latest ufs-sysfs changes, it al=
so
> takes care to restore auto-hibernate during resume, and otherwise avoids
> updating the register if the device is runtime suspended.  Also a default
> value of 150ms is set.

Applied to 4.17/scsi-queue. Thank you!

--=20
Martin K. Petersen	Oracle Linux Engineering
