From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: ibmvscsis: Fix error return code in ibmvscsis_probe()
Date: Thu, 15 Sep 2016 09:57:14 -0400
Message-ID: <yq1bmzpz2o5.fsf@sermon.lab.mkp.net>
References: <1473909923-30014-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1473909923-30014-1-git-send-email-weiyj.lk@gmail.com> (Wei
        Yongjun's message of "Thu, 15 Sep 2016 03:25:23 +0000")
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "Bryant G . Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Yongjun <weiyj.lk@gmail.com> writes:

Wei> From: Wei Yongjun <weiyongjun1@huawei.com> Fix to return error code
Wei> -ENOMEM from the dma mapping error handling case instead of 0, as
Wei> done elsewhere in this function.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
