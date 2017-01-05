From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/13] be2iscsi: driver update 11.2.1.0
Date: Thu, 05 Jan 2017 00:17:51 -0500
Message-ID: <yq1h95ekruo.fsf@oracle.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:30276 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759877AbdAEFT1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 00:19:27 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v055J2xi027176
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2017 05:19:02 GMT
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
        (Jitendra Bhivare's message of "Tue, 13 Dec 2016 15:55:53 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: cleech@redhat.com, lduncan@suse.com, linux-scsi@vger.kernel.org

>>>>> "Jitendra" == Jitendra Bhivare <jitendra.bhivare@broadcom.com> writes:

Jitendra> This patch is generated against for-next branch.  v2 changes:
Jitendra>   +be2iscsi: Reinit SGL handle, CID tables after TPE

Jitendra> Jitendra Bhivare (12):
Jitendra>   be2iscsi: Fix use of invalidate command table req be2iscsi:
Jitendra>   Fix for crash in beiscsi_eh_device_reset be2iscsi: Take
Jitendra>   iscsi_task ref in abort handler be2iscsi: Set WRB invalid
Jitendra>   bit for SkyHawk be2iscsi: Add checks to validate completions
Jitendra>   be2iscsi: Fix iSCSI cmd cleanup IOCTL be2iscsi: Remove
Jitendra>   redundant receive buffers posting be2iscsi: Remove unused
Jitendra>   struct members be2iscsi: Remove wq_name from beiscsi_hba
Jitendra>   be2iscsi: Add checks to validate CID alloc/free be2iscsi:
Jitendra>   Reinit SGL handle, CID tables after TPE be2iscsi: Update
Jitendra>   driver version

Jitendra> Ketan Mukadam (1):
Jitendra>   be2iscsi: Add warning message for unsupported adapter

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
