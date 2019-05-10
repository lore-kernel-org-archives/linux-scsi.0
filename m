From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: qedi: remove memset/memcpy to nfunc and use func
 instead
Date: Fri, 10 May 2019 14:29:20 +0300
Message-ID: <20190510112920.GD18105@kadam>
References: <20190412094829.15868-1-colin.king@canonical.com>
 <20190420040554.41888-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190420040554.41888-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.ibm.com, martin.petersen@oracle.com, mojha@codeaurora.org, skashyap@marvell.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It took me a while to figure out that this is almost the same as Colin's
qedf patch but for qedi.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
