From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bfa: use ARRAY_SIZE for array sizing calculation on array __pciids
Date: Wed, 10 Jan 2018 16:51:33 -0500
Message-ID: <yq1lgh5v0uy.fsf@oracle.com>
References: <20180107231510.7755-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180107231510.7755-1-colin.king@canonical.com> (Colin King's
        message of "Sun, 7 Jan 2018 23:15:10 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Use the ARRAY_SIZE macro on array __pciids to determine size of the array.
> Improvement suggested by coccinelle.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
