From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi: remove declaration of nvm_image from stack
Date: Fri, 29 Mar 2019 10:04:53 -0400
Message-ID: <yq1d0m9srne.fsf@oracle.com>
References: <20190327181103.15677-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327181103.15677-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 27 Mar 2019 18:11:03 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The nvm_image is a large struct qedi_nvm_iscsi_image object of over
> 24K so don't declare it on the stack just for a sizeof requirement;
> use sizeof on struct qedi_nvm_iscsi_image instead.

Applied to 5.1/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
