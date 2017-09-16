From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] csi: libcxgbi: remove redundant check and close on csk
Date: Fri, 15 Sep 2017 21:45:15 -0400
Message-ID: <yq1vakjs9g4.fsf@oracle.com>
References: <20170907135133.16636-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170907135133.16636-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 7 Sep 2017 14:51:33 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> csk is always null on the error return path and so the non-null check
> and call to cxgbi_sock_closed on csk is redundant and can be removed.

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
