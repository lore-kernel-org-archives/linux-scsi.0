From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][next] scsi: lpfc: make several unions static, fix non-ANSI prototype
Date: Wed, 14 Mar 2018 23:37:21 -0400
Message-ID: <yq1o9jq9fgu.fsf@oracle.com>
References: <20180313120849.30128-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313120849.30128-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 13 Mar 2018 12:08:49 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> There are several unions that are local to the source and do not need
> to be in global scope, so make them static. Also add in a missing void
> parameter to functions lpfc_nvme_cmd_template and
> lpfc_nvmet_cmd_template to clean up non-ANSI warning.

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
