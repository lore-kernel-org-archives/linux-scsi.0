From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][next] scsi: target: fix unsigned comparision with less than zero
Date: Wed, 20 Mar 2019 20:33:42 -0400
Message-ID: <yq1sgvh5amx.fsf@oracle.com>
References: <20190320163709.28767-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320163709.28767-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 20 Mar 2019 16:37:09 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Currently an error return is being assigned to an unsigned size_t
> varianle and then checked if the result is less than zero which will
> always be false.  Fix this by making ret ssize_t rather than a size_t.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
