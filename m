From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: ensure els_wq is being checked before destroying it
Date: Mon, 08 May 2017 22:12:27 -0400
Message-ID: <yq11srysrqs.fsf@oracle.com>
References: <20170506221355.13552-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170506221355.13552-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 6 May 2017 23:13:55 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> I believe there is a typo on the wq destroy of els_wq, currently the
> driver is checking if els_cq is not null and I think this should be a
> check on els_wq instead.

Applied to 4.12/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
