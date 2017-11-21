From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bfa: remove unused pointer 'port'
Date: Mon, 20 Nov 2017 22:22:37 -0500
Message-ID: <yq1zi7gl3ia.fsf@oracle.com>
References: <20171115170849.20413-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171115170849.20413-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 15 Nov 2017 17:08:49 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The pointer 'port' is being assigned but it is never read, hence it is
> redundant and can be removed. Cleans up clang warning:
>
> drivers/scsi/bfa/bfad_attr.c:505:2: warning: Value stored to 'port'
> is never read

Applied to 4.16/scsi-queue. Thanks, Colin!

-- 
Martin K. Petersen	Oracle Linux Engineering
