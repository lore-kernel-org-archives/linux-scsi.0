From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/mpt3sas: Use dma_pool_zalloc
Date: Wed, 10 Oct 2018 22:05:25 -0400
Message-ID: <yq1zhvl2q6y.fsf@oracle.com>
References: <20181002054804.GA11315@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002054804.GA11315@jordon-HP-15-Notebook-PC> (Souptick
        Joarder's message of "Tue, 2 Oct 2018 11:18:04 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, brajeswar.linux@gmail.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Souptick,

> Replaced dma_pool_alloc + memset with dma_pool_zalloc.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
