From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: don't dereference localport before it has been null checked
Date: Wed, 03 Jan 2018 22:53:10 -0500
Message-ID: <yq1k1wyxot5.fsf@oracle.com>
References: <20171222002852.10892-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171222002852.10892-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 22 Dec 2017 00:28:52 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> localport is being dereferenced to assign lport and then immediately
> afterwards localport is being sanity checked to see if it is null.
> Fix this by only dereferencing localport until after it has been
> null checked.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
