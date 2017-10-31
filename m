From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: hisi_sas: fix for the build error log_non_standard_event undefined
Date: Tue, 31 Oct 2017 12:33:02 -0400
Message-ID: <yq1zi879t1d.fsf@oracle.com>
References: <3f14f745-6fdf-4948-85bb-d21d565dbcab@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30878 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdJaQdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 12:33:22 -0400
In-Reply-To: <3f14f745-6fdf-4948-85bb-d21d565dbcab@huawei.com> (shiju jose's
        message of "Tue, 31 Oct 2017 12:25:51 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: shiju.jose@huawei.com
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, xuwei5@hisilicon.com


Shiju,

> This patch fix the build error log_non_standard_event undefined
> for the i386 build for COMPILE_TEST.

This is messy. You have one patch addressing build problems in two
different patches. This breaks our ability to bisect.

I combined the ECC and AXI patches into one and then added the build fix
on top. Really hope that works.

-- 
Martin K. Petersen	Oracle Linux Engineering
