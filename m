From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/lpfc/lpfc_sli.c: Use dma_zalloc_coherent
Date: Wed, 21 Nov 2018 22:32:02 -0500
Message-ID: <yq1wop56b4d.fsf@oracle.com>
References: <5bf1797b.1c69fb81.2368c.1ccc@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bf1797b.1c69fb81.2368c.1ccc@mx.google.com> (Sabyasachi Gupta's
        message of "Sun, 18 Nov 2018 20:08:48 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org


Sabyasachi,

> Replaced dma_alloc_coherent + memset with dma_zalloc_coherent

Applied to 4.21/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
