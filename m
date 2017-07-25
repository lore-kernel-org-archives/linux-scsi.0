From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: megaraid_sas: fix memleak in megasas_alloc_cmdlist_fusion
Date: Mon, 24 Jul 2017 22:05:13 -0400
Message-ID: <yq1r2x51dba.fsf@oracle.com>
References: <1500634449-10837-1-git-send-email-shuwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27851 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753098AbdGYCFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 22:05:35 -0400
In-Reply-To: <1500634449-10837-1-git-send-email-shuwang@redhat.com>
        (shuwang@redhat.com's message of "Fri, 21 Jul 2017 18:54:09 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: shuwang@redhat.com
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuhu@redhat.com, liwang@redhat.com


shuwang@redhat.com,

> Found this issue by kmemleak, a few kb mem was leaked in
> megasas_alloc_cmdlist_fusion when kzalloc failed for one
> megasas_cmd_fusion allocation.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
