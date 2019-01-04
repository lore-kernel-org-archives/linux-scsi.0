From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: qla4xxx: check return code of qla4xxx_copy_from_fwddb_param
Date: Fri, 04 Jan 2019 01:04:37 -0500
Message-ID: <yq1ef9t6jre.fsf@oracle.com>
References: <20181220031607.10588-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181220031607.10588-1-yuehaibing@huawei.com> (YueHaibing's
        message of "Thu, 20 Dec 2018 11:16:07 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> The return code should be check while qla4xxx_copy_from_fwddb_param
> fails.

Applied to 4.21/scsi-fixes, thank you.

-- 
Martin K. Petersen	Oracle Linux Engineering
