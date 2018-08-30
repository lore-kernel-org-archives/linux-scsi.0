From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: remove unused variables dev and cpu
Date: Thu, 30 Aug 2018 07:25:37 -0400
Message-ID: <yq1zhx43xla.fsf@oracle.com>
References: <20180816133320.19682-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180816133320.19682-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 16 Aug 2018 14:33:20 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Variables dev and cpu are not being used and are redundant and hence
> can be removed.
>
> Cleans up clang warnings:
> warning: variable 'dev' set but not used [-Wunused-but-set-variable]
> warning: variable 'cpu' set but not used [-Wunused-but-set-variable]

Applied to 4.20/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
