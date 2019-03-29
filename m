From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pm8001: clean up structurally dead code when PM8001_USE_MSIX is defined
Date: Fri, 29 Mar 2019 10:14:41 -0400
Message-ID: <yq1zhpdrcmm.fsf@oracle.com>
References: <20190328234328.15860-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328234328.15860-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 28 Mar 2019 23:43:28 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> When macro PM8001_USE_MSIX is defined there are redundant dead code
> calls to pm8001_chip_intx_interrupt_{enable|disable}. Clean this up by
> compiling in the appropriate enable/disable handlers for the defined
> PM8001_USE_MSIX and undefined PM8001_USE_MSIX cases.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
