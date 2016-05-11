From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] mpt3sas: driver update to Phase12.
Date: Wed, 11 May 2016 16:15:27 -0400
Message-ID: <yq1h9e4nyg0.fsf@sermon.lab.mkp.net>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
	(Chaitra P. B.'s message of "Fri, 6 May 2016 14:29:25 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chaitra" == Chaitra P B <chaitra.basappa@broadcom.com> writes:

Chaitra> Here is the change list: * Updated MPI version and MPI header
Chaitra> files.  * Handle active cable exception event for
Chaitra> Intruder/Cutlass HBAs.  * Use scsi_prot_ref_tag()API to fill
Chaitra> reference tag field in the CDB.  * Updated mpt3sas driver
Chaitra> version to Ph12 13.100.00.00 * Set maximum transfer length per
Chaitra> IO on RAID volumes to 4MB.  * Use "synchronize_irq()"API to
Chaitra> handle Asynchronous TM's completion.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
