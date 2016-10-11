From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH v3] scsi: ufshcd: fix possible unclocked register access
Date: Tue, 11 Oct 2016 17:55:16 -0400
Message-ID: <yq160oyo8jf.fsf@sermon.lab.mkp.net>
References: <1475815702-8624-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475815702-8624-1-git-send-email-subhashj@codeaurora.org>
        (Subhash Jadavani's message of "Thu, 6 Oct 2016 21:48:22 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Subhash" == Subhash Jadavani <subhashj@codeaurora.org> writes:

Subhash> Vendor specific setup_clocks callback may require the clocks
Subhash> managed by ufshcd driver to be ON. So if the vendor specific
Subhash> setup_clocks callback is called while the required clocks are
Subhash> turned off, it could result into unclocked register access.

Subhash> To prevent possible unclock register access, this change adds
Subhash> one more argument to setup_clocks callback to let it know
Subhash> whether it is called pre/post the clock changes by core driver.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
