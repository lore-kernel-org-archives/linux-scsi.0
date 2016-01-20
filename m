From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] hisi_sas: SCSI_HISI_SAS should depend on HAS_DMA
Date: Tue, 19 Jan 2016 19:24:20 -0500
Message-ID: <yq1wpr5qerv.fsf@sermon.lab.mkp.net>
References: <1452865149-32064-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:31050 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056AbcATBil (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 20:38:41 -0500
In-Reply-To: <1452865149-32064-1-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Fri, 15 Jan 2016 14:39:08 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Geert" == Geert Uytterhoeven <geert@linux-m68k.org> writes:

Geert> If NO_DMA=y: ERROR: "dma_map_sg"
Geert> [drivers/scsi/hisi_sas/hisi_sas_v1_hw.ko] undefined!  ERROR:
Geert> "dma_pool_alloc" [drivers/scsi/hisi_sas/hisi_sas_v1_hw.ko]
Geert> undefined!  ERROR: "dma_unmap_sg"

Geert> Add a dependency on HAS_DMA to fix this.

Applied to 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
