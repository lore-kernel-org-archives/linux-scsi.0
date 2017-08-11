From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: megaraid_sas: fix allocate instance->pd_info twice
Date: Thu, 10 Aug 2017 20:05:10 -0400
Message-ID: <yq1tw1f2cll.fsf@oracle.com>
References: <20170808051549.GA11601@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20325 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbdHKAFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 20:05:20 -0400
In-Reply-To: <20170808051549.GA11601@bogon.didichuxing.com> (weiping zhang's
        message of "Tue, 8 Aug 2017 13:15:55 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org


weiping,

> fix allocate instance->pd_info twice which was introduced by
> 96188a89cc6d.

Applied to 4.14/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
