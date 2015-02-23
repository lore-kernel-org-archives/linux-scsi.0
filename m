From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: Re: [PATCH v3 0/4] Add ioctl and debug utilities to UFS driver
Date: Mon, 23 Feb 2015 09:10:31 -0000
Message-ID: <f6cac2ecf8933042ac82cbff3fb0e143.squirrel@www.codeaurora.org>
References: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

> Changes from V2:
> Fixed comment for debugfs change:
> Added missing clean up to driver unload path and remove redundant macros.
>
> Dolev Raviv (1):
>   scsi: ufs: add ioctl interface for query request
>
> Gilad Broner (1):
>   scsi: ufs: add trace events and dump prints for debug
>
> Lee Susman (1):
>   scsi: ufs: add debugfs for ufs
>
> Sujit Reddy Thumma (1):
>   scsi: ufs: inject errors to verify error handling
>
>  drivers/scsi/ufs/Makefile      |    1 +
>  drivers/scsi/ufs/ufs-debugfs.c | 1042
> ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-debugfs.h |   42 ++
>  drivers/scsi/ufs/ufs-qcom.c    |   53 ++
>  drivers/scsi/ufs/ufs.h         |   53 +-
>  drivers/scsi/ufs/ufshcd.c      |  959
> ++++++++++++++++++++++++++++++++++--
>  drivers/scsi/ufs/ufshcd.h      |  115 +++++
>  drivers/scsi/ufs/ufshci.h      |    3 +
>  include/trace/events/ufs.h     |  227 +++++++++
>  include/uapi/scsi/Kbuild       |    1 +
>  include/uapi/scsi/ufs/Kbuild   |    3 +
>  include/uapi/scsi/ufs/ioctl.h  |   57 +++
>  include/uapi/scsi/ufs/ufs.h    |   66 +++
>  lib/Kconfig.debug              |   14 +
>  14 files changed, 2552 insertions(+), 84 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufs-debugfs.c
>  create mode 100644 drivers/scsi/ufs/ufs-debugfs.h
>  create mode 100644 include/trace/events/ufs.h
>  create mode 100644 include/uapi/scsi/ufs/Kbuild
>  create mode 100644 include/uapi/scsi/ufs/ioctl.h
>  create mode 100644 include/uapi/scsi/ufs/ufs.h
>
> --
> Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Reviewed-by: Dov Levenglick <dovl@codeaurora.org>

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
