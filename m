From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi: qla2xxx: use dma_mapping_error to check map errors
Date: Thu, 10 Aug 2017 20:06:02 -0400
Message-ID: <yq1h8xf2ck5.fsf@oracle.com>
References: <1502200531-15219-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502200531-15219-1-git-send-email-bianpan2016@163.com> (Pan
        Bian's message of "Tue, 8 Aug 2017 21:55:30 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Pan,

> The return value of dma_map_single() should be checked by
> dma_mapping_error(). However, in function qla26xx_dport_diagnostics(),
> its return value is checked against NULL, which could result in
> failures.

Applied to 4.14/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
