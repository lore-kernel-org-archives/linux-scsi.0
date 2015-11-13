From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Fix use sas_is_tlr_enabled API before enabling MPI2_SCSIIO_CONTROL_TLR_ON flag
Date: Fri, 13 Nov 2015 15:46:02 -0500
Message-ID: <yq1oaexzkz9.fsf@sermon.lab.mkp.net>
References: <1447351837-31388-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447351837-31388-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 12 Nov 2015 23:40:37 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> Before enabling MPI2_SCSIIO_CONTROL_TLR_ON flag in MPI SCSI
Sreekanth> IO request message, check whether TLR is enabled on the drive
Sreekanth> using 'sas_is_tlr_enabled' API.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
