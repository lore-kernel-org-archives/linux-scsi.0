From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/4] mpt3sas driver Enhancements and defect fixes:
Date: Tue, 31 Jan 2017 22:04:01 -0500
Message-ID: <yq1o9ymzk66.fsf@oracle.com>
References: <1485165370-43401-1-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485165370-43401-1-git-send-email-chaitra.basappa@broadcom.com>
        (Chaitra P. B.'s message of "Mon, 23 Jan 2017 15:26:06 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chaitra" == Chaitra P B <chaitra.basappa@broadcom.com> writes:

Chaitra> Here is the change list: Posting 4 patches for mpt3sas driver
Chaitra> enhancement and defect fixes.  * Handle cable event for
Chaitra> notifying degraded speed.  * Performance improvement for
Chaitra> Crusader.  * Fix Firmware fault state 0x2100 during heavy 4K RR
Chaitra> FIO stress test.  * Updated driver version to 15.100.00.00

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
