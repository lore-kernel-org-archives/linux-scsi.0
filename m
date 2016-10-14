From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] Locking issue in libiscsi and be2iscsi
Date: Fri, 14 Oct 2016 16:50:26 -0400
Message-ID: <yq1twceirjh.fsf@sermon.lab.mkp.net>
References: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49785 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756821AbcJNUuh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 16:50:37 -0400
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

Somebody please review.

-- 
Martin K. Petersen	Oracle Linux Engineering
