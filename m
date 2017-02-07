From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][V2] scsi: aacraid: rcode is unsigned and should be signed int
Date: Tue, 07 Feb 2017 17:23:24 -0500
Message-ID: <yq1efz9prmr.fsf@oracle.com>
References: <20170207115129.18948-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170207115129.18948-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 7 Feb 2017 11:51:29 +0000")
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> aac_fib_send can return -ve error returns and hence rcode should
Colin> be signed. Currently the rcode >= 0 check is always true and -ve
Colin> errors are not being checked.

Colin> Thanks to Dan Carpenter for spotting my original broken fix to
Colin> this issue.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
