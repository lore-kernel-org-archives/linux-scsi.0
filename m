From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH] mpt3sas: support target smid for [abort|query] task
Date: Tue, 30 Jul 2019 16:02:44 -0400
Message-ID: <yq1sgqnl28r.fsf@oracle.com>
References: <20190727185337.19299-1-minwoo.im.dev@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190727185337.19299-1-minwoo.im.dev@gmail.com> (Minwoo Im's
        message of "Sun, 28 Jul 2019 03:53:37 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: Minwoo Im <minwoo.im.dev@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Euihyeok Kwon <eh81.kwon@samsung.com>, Sarah Cho <sohyeon.jo@samsung.com>, Sanggwan Lee <sanggwan.lee@samsung.com>, Gyeongmin Nam <gm.nam@samsung.com>, Sungjun Park <sj1228.park@samsung.com>, Minwoo Im <minwoo.im@samsung.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org


Minwoo,

> We can request task management IOCTL
> command(MPI2_FUNCTION_SCSI_TASK_MGMT) to /dev/mpt3ctl.  If the given
> task_type is either abort task or query task, it may need a field
> named "Initiator Port Transfer Tag to Manage" in the IU.

Applied to 5.4/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
