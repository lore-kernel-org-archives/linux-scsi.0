From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][scsi-next] scsi: qla2xxx: remove redundant null check on tgt
Date: Mon, 12 Jun 2017 21:12:07 -0400
Message-ID: <yq1h8zkzo60.fsf@oracle.com>
References: <20170605172958.12844-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170605172958.12844-1-colin.king@canonical.com> (Colin King's
        message of "Mon, 5 Jun 2017 18:29:58 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> An earlier commit ed7fb808477b846bb2 ("scsi: qla2xxx: Remove redundant
> wait when target is stopped.") removed a null check on ha->tgt.tgt_ops
> and replaced it with a new check that null checked tgt, thus making
> the subsequent null check on tgt totally redundant. Remove it.

Applied to 4.13/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
