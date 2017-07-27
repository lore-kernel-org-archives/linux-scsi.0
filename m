From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/6] qla2xxx: Bug fixes for driver
Date: Wed, 26 Jul 2017 21:58:01 -0400
Message-ID: <yq1eft2y72u.fsf@oracle.com>
References: <20170721163228.32339-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46501 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdG0B6L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2017 21:58:11 -0400
In-Reply-To: <20170721163228.32339-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Fri, 21 Jul 2017 09:32:22 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> This series addresses review comments for previously submitted series for
> target multiqueue and FC-NVMe support in 4.13.0-rc1
>
> Patches 1,2 addresses review comments by Johannes for FC-NVMe series
> (https://www.spinics.net/lists/linux-scsi/msg110077.html)
> (https://www.spinics.net/lists/linux-scsi/msg109985.html)
>
> Patch 3 adds ZIO support for FC-NVMe
>
> Patch 4 simplifies unregistration of local/remote FC-NVMe ports.
>
> Patch 5 fixes handling of remote-port disconnect for FC-NVMe.
>
> Patch 6 addresses review comments by Bart for Target Multiqueue series.
> (https://www.spinics.net/lists/target-devel/msg15563.html)

It seems to me like patch 5 is the only bug fix candidate for 4.13 and
the rest of these should go into 4.14?

-- 
Martin K. Petersen	Oracle Linux Engineering
