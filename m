From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/5] mpt3sas: driver update for Phase12
Date: Wed, 27 Apr 2016 21:10:45 -0400
Message-ID: <yq11t5qedwq.fsf@sermon.lab.mkp.net>
References: <1461324194-5789-1-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461324194-5789-1-git-send-email-chaitra.basappa@broadcom.com>
	(Chaitra P. B.'s message of "Fri, 22 Apr 2016 16:53:09 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chaitra" == Chaitra P B <chaitra.basappa@broadcom.com> writes:

> Here is the change list:
> * Updated MPI version and MPI header files.
> * Handle active cable exception event for Intruder/Cutlass HBAs.
> * Use scsi_prot_ref_tag()API to fill reference tag field in the CDB.
> * Set maximum transfer length per IO on RAID volumes to 4MB.
> * Use "synchronize_irq()"API to handle Asynchronous TM's completion

> Chaitra P B (5):
>   mpt3sas: Update MPI header to 2.00.42
>   mpt3sas: Handle active cable exception event
>   mpt3sas: Fix initial Reference tag field for 4K PI drives.
>   mpt3sas: Set maximum transfer length per IO to 4MB for VDs
>   mpt3sas: Used "synchronize_irq()"API to synchronize timed-out IO &
>     TMs

Somebody please review.

-- 
Martin K. Petersen	Oracle Linux Engineering
