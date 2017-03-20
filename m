From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libsas: fix ata xfer length
Date: Mon, 20 Mar 2017 10:21:39 -0400
Message-ID: <yq1d1dchvv0.fsf@oracle.com>
References: <1489676848-103256-1-git-send-email-john.garry@huawei.com>
        <yq160j5ji6n.fsf@oracle.com>
        <f5d6b941-f981-b05f-6266-9364878e135f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40234 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754968AbdCTOVz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2017 10:21:55 -0400
In-Reply-To: <f5d6b941-f981-b05f-6266-9364878e135f@huawei.com> (John Garry's
        message of "Mon, 20 Mar 2017 08:59:40 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Tejun Heo <tj@kernel.org>

John Garry <john.garry@huawei.com> writes:

> I should have added this originally to the changelog:
> Fixes: ff2aeb1eb64c8a4770a6 ("libata: convert to chained sg")

Added.

-- 
Martin K. Petersen	Oracle Linux Engineering
