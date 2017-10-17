From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Fix a precedence bug in lpfc_nvme_io_cmd_wqe_cmpl()
Date: Mon, 16 Oct 2017 22:44:15 -0400
Message-ID: <yq1o9p61ojk.fsf@oracle.com>
References: <20171012203057.ixo2ds5i5ecbyv4y@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20171012203057.ixo2ds5i5ecbyv4y@mwanda> (Dan Carpenter's message
        of "Thu, 12 Oct 2017 23:30:57 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Dan,

> The ! has higher precedence than the & operation.  I've added
> parenthesis so this works as intended.

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
