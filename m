From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] libsas: SATA PHY connection rate matching during disovery
Date: Fri, 11 Jan 2019 22:15:23 -0500
Message-ID: <yq1h8eewoqc.fsf@oracle.com>
References: <1546617688-240623-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546617688-240623-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Sat, 5 Jan 2019 00:01:25 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset looks to resolve an issue we see whereby a SATA end device
> negotiated linkrate may exceed the min linkrate to the initiator, and
> not be able to establish a connection.

Looks good to me. Applied to 5.1/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
