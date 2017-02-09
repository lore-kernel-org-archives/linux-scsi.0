From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: qedi: Fix possible memory leak in qedi_iscsi_update_conn()
Date: Thu, 09 Feb 2017 18:35:45 -0500
Message-ID: <yq1y3xfj5ta.fsf@oracle.com>
References: <20170207145258.31429-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:46771 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbdBIXiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 18:38:04 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v19NbSql009540
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2017 23:37:28 GMT
In-Reply-To: <20170207145258.31429-1-weiyj.lk@gmail.com> (Wei Yongjun's
        message of "Tue, 7 Feb 2017 14:52:58 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Manish Rangankar <manish.rangankar@cavium.com>, Wei Yongjun <weiyongjun1@huawei.com>, QLogic-Storage-Upstream@cavium.com, linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Yongjun <weiyj.lk@gmail.com> writes:

Wei> 'conn_info' is malloced in qedi_iscsi_update_conn() and should be
Wei> freed before leaving from the error handling cases, otherwise it
Wei> will cause memory leak.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
