From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi, block: fix memory leak of sdpk on when gd fails to allocate
Date: Wed, 22 Feb 2017 19:19:02 -0500
Message-ID: <yq1a89d92tl.fsf@oracle.com>
References: <20170203193854.6782-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170203193854.6782-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 3 Feb 2017 19:38:54 +0000")
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> On an allocation failure of gd, the current exit path is via
Colin> out_free_devt which leaves sdpk still allocated and hence it gets
Colin> leaked. Fix this by correcting the order of resource free'ing
Colin> with a change in the error exit path labels.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
