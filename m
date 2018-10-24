From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/mvsas/mv_sas.c: Use dma_pool_zalloc
Date: Tue, 23 Oct 2018 21:26:58 -0400
Message-ID: <yq15zxsgmn1.fsf@oracle.com>
References: <5bc8af85.1c69fb81.3eebc.a22b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bc8af85.1c69fb81.3eebc.a22b@mx.google.com> (Sabyasachi Gupta's
        message of "Thu, 18 Oct 2018 21:36:26 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, keescook@chromium.org, john.garry@huawei.com, jinpu.wang@profitbricks.com, jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org


Sabyasachi,

> Replaced dma_pool_alloc + memset with dma_pool_zalloc

Applied to 4.20/scsi-queue, thank you.

-- 
Martin K. Petersen	Oracle Linux Engineering
