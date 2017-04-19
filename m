From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: fix potential buffer overflow.
Date: Tue, 18 Apr 2017 22:01:31 -0400
Message-ID: <yq14lxltatg.fsf@oracle.com>
References: <1492509351-25441-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41169 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757172AbdDSCBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 22:01:40 -0400
In-Reply-To: <1492509351-25441-1-git-send-email-mlombard@redhat.com> (Maurizio
        Lombardi's message of "Tue, 18 Apr 2017 11:55:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org, emilne@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

Maurizio Lombardi <mlombard@redhat.com> writes:

> This patch fixes a potential buffer overflow in lpfc_nvme_info_show().

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
