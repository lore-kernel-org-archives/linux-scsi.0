From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Correct MDS diag and nvmet configuration
Date: Thu, 23 Aug 2018 22:13:21 -0400
Message-ID: <yq18t4wa4vy.fsf@oracle.com>
References: <20180816230405.14272-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180816230405.14272-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 16 Aug 2018 16:04:05 -0700")
Sender: stable-owner@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org


James,

> A recent change added some MDS processing in the lpfc_drain_txq
> routine that relies on the fcp_wq being allocated. For nvmet operation
> the fcp_wq is not allocated because it can only be an nvme-target.
> When the original MDS support was added LS_MDS_LOOPBACK was defined
> wrong, (0x16) it should have been 0x10 (decimal value used for hex
> setting). This incorrect value allowed MDS_LOOPBACK to be set
> simultaneously with LS_NPIV_FAB_SUPPORTED, causing the driver to crash
> when it accesses the non-existent fcp_wq.
>
> Correct the bad value setting for LS_MDS_LOOPBACK.

Applied to 4.19/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
