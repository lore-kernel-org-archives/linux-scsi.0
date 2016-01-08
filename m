From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] cxgbi: typo in MODULE_PARM_DESC
Date: Fri, 08 Jan 2016 12:52:11 -0500
Message-ID: <yq17fjkez78.fsf@sermon.lab.mkp.net>
References: <20160108110136.GG32195@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160108110136.GG32195@mwanda> (Dan Carpenter's message of "Fri,
	8 Jan 2016 14:01:36 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> The module_param is "cxgb3i_rx_credit_thres" so the
Dan> MODULE_PARM_DESC() should match that.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
