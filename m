From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pmcraid: remove redundant initializations of pointer 'ioadl'
Date: Fri, 09 Feb 2018 18:52:51 -0500
Message-ID: <yq1lgg1u3e4.fsf@oracle.com>
References: <20180206143410.32210-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180206143410.32210-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 6 Feb 2018 14:34:10 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> There are several occurrances where pointer ioadl is initialized with a
> value that is never read and where it is re-assigned a new value later
> on, hence the initialization is redundant and can be removed.

Applied to 4.17/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
