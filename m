From: Kyuho Choi <chlrbgh0@gmail.com>
Subject: Re: [PATCH 0/7] Enable UFS provisioning via Linux
Date: Mon, 4 Jun 2018 20:11:19 +0900
Message-ID: <CAP2JTQJaYKoYANe6C68HnkVzT6eYUq9wJQxuy71LqQ72dacv_w@mail.gmail.com>
References: <20180529181740.195362-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Hi Evan,

I've some question about end user's provisioning.

On 5/30/18, Evan Green <evgreen@chromium.org> wrote:
> This series enables provisioning UFS devices using the existing sysfs
> interface. This functionality is primarily useful along the assembly
> line, but might also be useful for end users that receive devices that
> aren't locked down.

As we knew, ufs are mainly adopted to boot device like mobile phone.
Usally after  provisioning operation, every data in ufs (eg. Android :
system, userdata, boot info and etc) would be removed. How end user
download and flash all data to ufs?. dd or another download tools?.

>
> Evan Green (7):
>   scsi: ufs: Add Configuration Descriptor to sysfs
>   scsi: ufs: Add config descriptor documentation
>   scsi: ufs: Make sysfs attributes writable
>   scsi: ufs: sysfs: Document attribute writability
>   scsi: ufs: Refactor descriptor read for write
>   scsi: ufs: Enable writing config descriptor
>   scsi: ufs: Update config descriptor documentation
>
>  Documentation/ABI/testing/sysfs-driver-ufs | 174 ++++++++++++++++++++---
>  drivers/scsi/ufs/ufs-sysfs.c               | 217
> ++++++++++++++++++++++++++---
>  drivers/scsi/ufs/ufs.h                     |  29 ++++
>  drivers/scsi/ufs/ufshcd.c                  |  89 ++++++++----
>  drivers/scsi/ufs/ufshcd.h                  |  16 ++-
>  5 files changed, 458 insertions(+), 67 deletions(-)
>
> --
> 2.13.5
>
>
