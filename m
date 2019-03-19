From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mvsas: clean up a few indentation issues
Date: Tue, 19 Mar 2019 17:14:14 -0400
Message-ID: <yq1sgvibm8p.fsf@oracle.com>
References: <20190202103035.16043-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202103035.16043-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 2 Feb 2019 10:30:35 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> There are a few statements that are not indented correctly, so fix
> these. Also add empty line between variable declaration and first
> statements in functions. Also remove whitespace between * and mvi_dev
> to clean up a cppcheck warning.

Applied to 5.2/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
