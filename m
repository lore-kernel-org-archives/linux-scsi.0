From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] mpt3sas: Deallocate resources before trying reallocation of the same in _base_allocate_memory_pools()
Date: Wed, 17 Feb 2016 18:53:58 -0500
Message-ID: <yq18u2iuc4p.fsf@sermon.lab.mkp.net>
References: <1455708326-7584-1-git-send-email-chaitra.basappa@broadcom.com>
	<1455708326-7584-2-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455708326-7584-2-git-send-email-chaitra.basappa@broadcom.com>
	(Chaitra P. B.'s message of "Wed, 17 Feb 2016 16:55:25 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chaitra" == Chaitra P B <chaitra.basappa@broadcom.com> writes:

Chaitra> Deallocates resources before reallocating of the same in
Chaitra> retry_allocation path of _base_allocate_memory_pools()

Johannes' comments about kfree() aside, this patch does not apply to
4.6/scsi-queue which has the driver update from Suganath. Please rebase
and resubmit.

-- 
Martin K. Petersen	Oracle Linux Engineering
