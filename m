From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedf: remove redundant initialization of 'fcport'
Date: Tue, 06 Feb 2018 20:25:39 -0500
Message-ID: <yq1372d1tgs.fsf@oracle.com>
References: <20180206140316.31453-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180206140316.31453-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 6 Feb 2018 14:03:16 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Pointer fcport is initialized with a value that is never read, it is
> re-assigned a new value later on, hence the initialization is redundant
> and can be removed.

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
