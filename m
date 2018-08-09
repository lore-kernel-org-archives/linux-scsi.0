From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] st: remove redundant pointer STbuffer
Date: Wed, 08 Aug 2018 21:16:42 -0400
Message-ID: <yq136vos5j9.fsf@oracle.com>
References: <20180803104752.17081-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180803104752.17081-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 3 Aug 2018 11:47:52 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Pointer STbuffer is being assigned but is never used hence it is
> redundant and can be removed.
>
> Cleans up clang warning:
> warning: variable 'STbuffer' set but not used [-Wunused-but-set-variable]

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
