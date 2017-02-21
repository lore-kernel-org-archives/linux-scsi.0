From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] qla2xxx: Bug fixes and cleanup for the driver.
Date: Mon, 20 Feb 2017 22:16:04 -0500
Message-ID: <yq1d1ec44jv.fsf@oracle.com>
References: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46855 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdBUDQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 22:16:14 -0500
In-Reply-To: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
        (Himanshu Madhani's message of "Wed, 15 Feb 2017 15:37:18 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Himanshu" == Himanshu Madhani <himanshu.madhani@cavium.com> writes:

Hi Himanshu,

Himanshu> This series contains small cleanup + fix for regression that
Himanshu> was introduced by pci_alloc_irq_vectors_affinity() call in
Himanshu> driver.

Himanshu> Please apply this series to 4.10/scsi-fixes at your earliest
Himanshu> convenience.

4.10 is out and this series does not apply to 4.11/scsi-queue. Please
rebase.

Also, please make sure your "Fixes: d745952 ("scsi: qla2xxx:..." have a
12-char hash. And add a stable tag if you want these in 4.10.x.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
