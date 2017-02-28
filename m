From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: remove redundant zero check on ret
Date: Mon, 27 Feb 2017 22:20:32 -0500
Message-ID: <yq1shmzvw5b.fsf@oracle.com>
References: <20170224144330.6707-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170224144330.6707-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 24 Feb 2017 14:43:30 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin,

Colin> The check for ret being zero is redundant as a few statements
Colin> earlier we break out of the while loop if ret is non-zero.  Thus
Colin> we can remove the zero check and also the dead-code non-zero case
Colin> too.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
