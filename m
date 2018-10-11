From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: arcmsr: clean up clang warning on extraneous parentheses
Date: Wed, 10 Oct 2018 23:22:28 -0400
Message-ID: <yq1woqp1823.fsf@oracle.com>
References: <20180930230307.18664-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180930230307.18664-1-colin.king@canonical.com> (Colin King's
        message of "Mon, 1 Oct 2018 00:03:07 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> There are extraneous parantheses that are causing clang to produce a
> warning so remove these.
>
> Clean up 3 clang warnings:
> equality comparison with extraneous parentheses [-Wparentheses-equality]

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
