From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libsas: remove unused variable sas_ha
Date: Wed, 27 Sep 2017 21:50:20 -0400
Message-ID: <yq1lgkz8ucj.fsf@oracle.com>
References: <20170926191750.25444-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170926191750.25444-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 26 Sep 2017 20:17:50 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: John Garry <john.garry@huawei.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Remove unused variable sas_ha to clean up build warning
> "unused variable ‘sas_ha’ [-Wunused-variable]"

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
