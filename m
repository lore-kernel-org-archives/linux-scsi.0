From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bfa: clean up a couple of indentation issues
Date: Wed, 19 Dec 2018 21:55:19 -0500
Message-ID: <yq1va3oewko.fsf@oracle.com>
References: <20181215142809.31115-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181215142809.31115-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 15 Dec 2018 14:28:09 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> There is a break statement with an extra space that needs removed and
> a call to bfa_trc that is indented one level too much. Fix these.

Applied to 4.21/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
