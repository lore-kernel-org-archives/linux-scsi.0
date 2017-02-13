From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/39] megaraid_sas: Updates for scsi-next
Date: Mon, 13 Feb 2017 07:28:21 -0500
Message-ID: <yq1a89qgtqy.fsf@oracle.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42314 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbdBMM3g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 07:29:36 -0500
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        (Shivasharan S.'s message of "Fri, 10 Feb 2017 00:59:00 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

>>>>> "Shivasharan" == Shivasharan S <shivasharan.srikanteshwara@broadcom.com> writes:

Shivasharan> Changes in v3: Patch 21: Fix to pass rctx_g35 pointer to
Shivasharan> set/get_num_sge() Move all v2 changelog descriptions beyond
Shivasharan> actual commit message body

Applied to 4.11/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
