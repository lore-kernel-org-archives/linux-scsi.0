From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date: Tue, 30 Jul 2019 12:47:33 -0400
Message-ID: <yq1mugvmpui.fsf@oracle.com>
References: <1564472637-8062-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1564472637-8062-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu's message of "Tue, 30 Jul 2019 03:43:57 -0400")
Sender: stable-owner@vger.kernel.org
To: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org


Suganath,

> Although SAS3 & SAS3.5 IT HBA controllers support 64-bit DMA
> addressing, as per hardware design, if DMA able range contains all
> 64-bits set (0xFFFFFFFF-FFFFFFFF) then it results in a firmware fault.

Applied to 5.3/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
