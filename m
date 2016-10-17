From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] Locking issue in libiscsi and be2iscsi
Date: Mon, 17 Oct 2016 13:36:40 -0400
Message-ID: <yq160oqj2s7.fsf@sermon.lab.mkp.net>
References: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26639 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933254AbcJQRhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 13:37:51 -0400
In-Reply-To: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
        (Jitendra Bhivare's message of "Thu, 13 Oct 2016 12:08:47 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: cleech@redhat.com, lduncan@suse.com, linux-scsi@vger.kernel.org

>>>>> "Jitendra" == Jitendra Bhivare <jitendra.bhivare@broadcom.com> writes:

Jitendra> These patches are being resent with required changes as per
Jitendra> comments for [PATCH 02/28] be2iscsi: Replace _bh with
Jitendra> _irqsave/irqrestore

Jitendra> In IO handling path, there is no spin_lock taken with IRQs
Jitendra> disabled when calling into libiscsi, so no issues were found
Jitendra> with use of spin_lock_bh/spin_unlock_bh except for one in
Jitendra> iscsi_eh_cmd_timeout.

Jitendra> This needs to be applied on top 11.2.0.0 of be2iscsi committed
Jitendra> in 4.9/scsi-queue.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
