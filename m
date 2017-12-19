From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedi: Fix a possible sleep-in-atomic bug in qedi_process_tmf_resp
Date: Mon, 18 Dec 2017 22:33:24 -0500
Message-ID: <yq1o9mvjssb.fsf@oracle.com>
References: <1513156268-13328-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513156268-13328-1-git-send-email-baijiaju1990@gmail.com>
        (Jia-Ju Bai's message of "Wed, 13 Dec 2017 17:11:08 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jia-Ju,

> To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.
>
> This bug is found by my static analysis tool(DSAC) and checked by my
> code review.

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
