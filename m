From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH V7 2/2] scsi: ufs: Add configfs support for UFS provisioning
Date: Mon, 6 Aug 2018 09:40:18 -0700
Message-ID: <CAE=gft46yHTxG5rpBLJ-x5AiETaGGdnsnEHjzSx2BsG4=sUKHA@mail.gmail.com>
References: <1533113338-31750-1-git-send-email-sayalil@codeaurora.org> <1533113338-31750-3-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533113338-31750-3-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayalil@codeaurora.org
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, adrian.hunter@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Sayali,

On Wed, Aug 1, 2018 at 1:49 AM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>
> This patch adds configfs support to provision UFS device at
> runtime. This feature can be primarily useful in factory or
> assembly line as some devices may be required to be configured
> multiple times during initial system development phase.
> Configuration Descriptors can be written multiple times until
> bConfigDescrLock attribute is zero.
>
> Configuration descriptor buffer consists of Device and Unit
> descriptor configurable parameters which are parsed from vendor
> specific provisioning file and then passed via configfs node at
> runtime to provision ufs device.
> CONFIG_CONFIGFS_FS needs to be enabled for using this feature.
>
> Usage:
> 1) To read current configuration descriptor :
>    cat /config/XXXX.ufshc/ufs_provision
> 2) To provision ufs device:
>    echo <config_desc_buf> > /config/XXXX.ufshc/ufs_provision
>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  Documentation/ABI/testing/configfs-driver-ufs |  18 +++
>  drivers/scsi/ufs/Kconfig                      |  10 ++
>  drivers/scsi/ufs/Makefile                     |   1 +
>  drivers/scsi/ufs/ufs-configfs.c               | 162 ++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c                     |   7 +-
>  drivers/scsi/ufs/ufshcd.h                     |  10 ++
>  6 files changed, 207 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
>  create mode 100644 drivers/scsi/ufs/ufs-configfs.c
>

You didn't address any of my feedback from V6. All of that still applies.
-Evan
