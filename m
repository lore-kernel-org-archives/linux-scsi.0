From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/aic94xx/aic94xx_hwi.c: Use dma_pool_zalloc
Date: Wed, 21 Nov 2018 22:06:29 -0500
Message-ID: <yq18t1l95fu.fsf@oracle.com>
References: <20181101041909.GA3241@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101041909.GA3241@jordon-HP-15-Notebook-PC> (Souptick
        Joarder's message of "Thu, 1 Nov 2018 09:49:09 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, keescook@chromium.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com, sabyasachi.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org


Souptick,

> Replaced dma_pool_alloc + memset with dma_pool_zalloc

Applied to 4.21/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
