From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] [SCSI] mpt fusion: fix error return code in mptfc_probe()
Date: Wed, 14 Sep 2016 14:27:12 -0400
Message-ID: <yq1lgyul4lb.fsf@sermon.lab.mkp.net>
References: <1473523596-6768-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31326 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753801AbcINS1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2016 14:27:25 -0400
In-Reply-To: <1473523596-6768-1-git-send-email-weiyj.lk@gmail.com> (Wei
        Yongjun's message of "Sat, 10 Sep 2016 16:06:36 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Wei Yongjun <weiyongjun1@huawei.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Yongjun <weiyj.lk@gmail.com> writes:

Wei> Fix to return error code -ENOMEM from the workqueue alloc error
Wei> handling case instead of 0, as done elsewhere in this function.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
