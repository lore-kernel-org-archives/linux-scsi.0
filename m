From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Schedule clk gating work on correct queue
Date: Wed, 17 Oct 2018 20:49:30 -0400
Message-ID: <yq1bm7sm63p.fsf@oracle.com>
References: <20181005172732.203793-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005172732.203793-1-evgreen@chromium.org> (Evan Green's
        message of "Fri, 5 Oct 2018 10:27:32 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, sayalil@codeaurora.org
List-Id: linux-scsi@vger.kernel.org


Evan,

> With commit 10e5e37581fc ("scsi: ufs: Add clock ungating to a separate
> workqueue"), clock gating work was moved to a separate work queue with
> WQ_MEM_RECLAIM set, since clock gating could occur from a memory
> reclaim context. Unfortunately, clk_gating.gate_work was left queued
> via schedule_delayed_work, which is a system workqueue that does not
> have WQ_MEM_RECLAIM set.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
