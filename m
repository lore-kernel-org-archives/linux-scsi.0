From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/12] scsi: ufs: add trace/debug support, sysfs controls and few fixes
Date: Thu, 05 Jan 2017 18:20:04 -0500
Message-ID: <yq1vattjdqz.fsf@oracle.com>
References: <1482460773-5931-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34404 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030936AbdAEXUh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 18:20:37 -0500
In-Reply-To: <1482460773-5931-1-git-send-email-subhashj@codeaurora.org>
        (Subhash Jadavani's message of "Thu, 22 Dec 2016 18:39:33 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Subhash" == Subhash Jadavani <subhashj@codeaurora.org> writes:

Subhash> This patch series adds following things:
Subhash>  - ftrace support to trace important events in UFS driver.
Subhash>  - debug dumps following failures to ease the debugging
Subhash>  - sysfs node to control clock gating, clock scaling and PM
Subhash>  - few fixes

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
