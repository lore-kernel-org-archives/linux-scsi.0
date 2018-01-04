From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 10/12] hpsa: drop unneeded newline
Date: Wed, 03 Jan 2018 23:29:42 -0500
Message-ID: <yq1r2r6w8jt.fsf@oracle.com>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>
        <1514386305-7402-11-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1514386305-7402-11-git-send-email-Julia.Lawall@lip6.fr> (Julia
        Lawall's message of "Wed, 27 Dec 2017 15:51:43 +0100")
Sender: kernel-janitors-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Don Brace <don.brace@microsemi.com>, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Julia,

> hpsa_show_dev_msg prints other information and a newline after the
> message string, so the message string does not need to include a
> newline explicitly.  Done using Coccinelle.

Applied to 4.16/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
