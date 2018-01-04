From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/9] scsi: qedi: Use zeroing allocator instead of allocator/memset
Date: Thu, 04 Jan 2018 01:17:31 -0500
Message-ID: <yq1shbmuozo.fsf@oracle.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
        <1514647712-6332-4-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514647712-6332-4-git-send-email-himanshujha199640@gmail.com>
        (Himanshu Jha's message of "Sat, 30 Dec 2017 20:58:26 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@adaptec.com, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Himanshu,

> Use dma_zalloc_coherent instead of dma_alloc_coherent followed by memset
> 0.

Does not apply to 4.16/scsi-queue. Please resubmit. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
