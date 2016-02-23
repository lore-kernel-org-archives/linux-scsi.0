From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/2] mpt3sas: Free memory pools before retrying to allocate with different value.
Date: Tue, 23 Feb 2016 17:38:11 -0500
Message-ID: <yq1vb5fjbn0.fsf@sermon.lab.mkp.net>
References: <1455784786-19086-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455784786-19086-1-git-send-email-suganath-prabu.subramani@broadcom.com>
	(Suganath Prabu Subramani's message of "Thu, 18 Feb 2016 14:09:45
	+0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Suganath" == Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com> writes:

Suganath> Deallocate resources before reallocating of the same in
Suganath> retry_allocation path of _base_allocate_memory_pools()

Both patches applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
