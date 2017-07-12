From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: isci: fix typo in function names
Date: Wed, 12 Jul 2017 17:10:32 -0400
Message-ID: <yq1r2xll5tj.fsf@oracle.com>
References: <20170703101727.12600-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170703101727.12600-1-colin.king@canonical.com> (Colin King's
        message of "Mon, 3 Jul 2017 11:17:27 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> There are a couple of typos in function names and spelling of request
> where the letters u and e are swapped:
>
> scu_ssp_reqeust_construct_task_context
> scu_sata_reqeust_construct_task_context
>
> Fix the spelling of request.

Applied to 4.13/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
