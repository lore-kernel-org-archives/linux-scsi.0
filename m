From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: Add softreset in hisi_sas_I_T_nexus_reset()
Date: Wed, 20 Mar 2019 14:25:40 -0400
Message-ID: <yq1k1gt8kt7.fsf@oracle.com>
References: <1553077294-129863-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553077294-129863-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 20 Mar 2019 18:21:34 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>
List-Id: linux-scsi@vger.kernel.org


John,

> We need to always follow an internal abort with a software reset, as
> per HW programming flow, so add this.

Mangled patch. Applied it by hand to 5.1/scsi-fixes but please use git
send-email.

-- 
Martin K. Petersen	Oracle Linux Engineering
