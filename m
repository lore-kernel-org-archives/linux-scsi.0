From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] mpt3sas: Fix - Remove cpumask_clear for zalloc_cpumask_var and dont free free_cpu_mask_var before reply_q
Date: Thu, 11 Feb 2016 10:00:29 -0500
Message-ID: <yq17fib5m2a.fsf@sermon.lab.mkp.net>
References: <1455183175-7741-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455183175-7741-1-git-send-email-suganath-prabu.subramani@avagotech.com>
	(Suganath prabu Subramani's message of "Thu, 11 Feb 2016 15:02:55
	+0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Suganath" == Suganath prabu Subramani <suganath-prabu.subramani@broadcom.com> writes:

Suganath> Removed cpumask_clear as it is not required for
Suganath> zalloc_cpumask_var and free free_cpumask_var before freeing
Suganath> reply_q.

Applied to 4.6/scsi-queue.

However, next time please submit two patches, one for each issue.

-- 
Martin K. Petersen	Oracle Linux Engineering
