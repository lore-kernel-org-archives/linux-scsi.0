From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi: libsas: fix length error in sas_smp_handler()
Date: Mon, 11 Dec 2017 21:46:56 -0500
Message-ID: <yq1h8swr7bz.fsf@oracle.com>
References: <20171211070333.12138-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35094 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbdLLCsP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2017 21:48:15 -0500
In-Reply-To: <20171211070333.12138-1-yanaijie@huawei.com> (Jason Yan's message
        of "Mon, 11 Dec 2017 15:03:33 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, john.garry@huawei.com, hch@lst.de, linux-scsi@vger.kernel.org, jthumshirn@suse.de, hare@suse.com


Jason,

> The return value of smp_execute_task_sg() is the untransferred
> residual, but bsg_job_done() requires the length of payload
> received. This makes SMP passthrough commands from userland by sg
> ioctl to libsas get a wrong response. The userland tools such as
> smp_utils failed becuase of these wrong responses:

Applied to 4.15/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
