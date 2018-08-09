From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: remove unnecessary query(DM) UPIU trace
Date: Wed, 08 Aug 2018 21:57:52 -0400
Message-ID: <yq1bmacqp27.fsf@oracle.com>
References: <1533475583-16939-1-git-send-email-ohad.sharabi@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533475583-16939-1-git-send-email-ohad.sharabi@wdc.com> (Ohad
        Sharabi's message of "Sun, 5 Aug 2018 16:26:23 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Ohad Sharabi <ohad.sharabi@wdc.com>
Cc: stanislav.nijnikov@wdc.com, avri.altman@wdc.com, alex.lemberg@wdc.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, gregkh@linuxfoundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ohad,

> This patch removes redundant trace that occurs when sending Device
> Management(DM) request (fix behavior in patch
> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/commit/?id=6667e6d91c88a788d5ab1b1e999d245473e84a9)
> Since the function send_command is called also for DM request, UPIU trace
> for DM request is called twice- one identified as query_* the other as
> send/complete.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
