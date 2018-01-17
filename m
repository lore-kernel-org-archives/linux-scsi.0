From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH -next] scsi: qedf: Fix error return code in
 __qedf_probe()
Date: Wed, 17 Jan 2018 09:40:14 -0500 (EST)
Message-ID: <alpine.OSX.2.00.1801170939230.964@n5113av3dljn32.qlogic.org>
References: <1516192961-52789-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1516192961-52789-1-git-send-email-weiyongjun1@huawei.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@cavium.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 17 Jan 2018, 7:42am, Wei Yongjun wrote:

> Fix to return error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/scsi/qedf/qedf_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 

Yeah, we should be returning -ENOMEM in those cases.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
