From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: lpfc: don't double count abort errors
Date: Sat, 01 Jul 2017 17:09:58 -0400
Message-ID: <yq1tw2vvp7d.fsf@oracle.com>
References: <20170630080352.mmfyjjxsznzx75yf@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170630080352.mmfyjjxsznzx75yf@mwanda> (Dan Carpenter's message
        of "Fri, 30 Jun 2017 11:03:53 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Dan,

> If lpfc_nvmet_unsol_fcp_issue_abort() fails then we accidentally
> increment "tgtp->xmt_abort_rsp_error" and then two lines later we
> increment it a second time.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
