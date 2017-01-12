From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: ufs: fix arguments order some trace calls
Date: Wed, 11 Jan 2017 22:36:00 -0500
Message-ID: <yq1tw95ne5b.fsf@oracle.com>
References: <1484095705-3962-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484095705-3962-1-git-send-email-subhashj@codeaurora.org>
        (Subhash Jadavani's message of "Tue, 10 Jan 2017 16:48:25 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, colin.king@canonical.com, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Subhash" == Subhash Jadavani <subhashj@codeaurora.org> writes:

Subhash> Colin Ian King <colin.king@canonical.com> reported that with
Subhash> commit 7ff5ab473633 ("scsi: ufs: add tracing support") static
Subhash> analysis is reporting that we may have swapped arguments on
Subhash> calls to:

[...]

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
