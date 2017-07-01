From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] scsi: Add STARGET_CREATED_REMOVE state to scsi_target_state
Date: Sat, 01 Jul 2017 16:55:46 -0400
Message-ID: <yq1k23rx4fh.fsf@oracle.com>
References: <1498589758-31473-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45801 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdGAUzv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2017 16:55:51 -0400
In-Reply-To: <1498589758-31473-1-git-send-email-emilne@redhat.com> (Ewan
        D. Milne's message of "Tue, 27 Jun 2017 14:55:58 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org


Ewan,

> The addition of the STARGET_REMOVE state had the side effect of
> introducing a race condition that can cause a crash.
>
> scsi_target_reap_ref_release() checks the starget->state to
> see if it still in STARGET_CREATED, and if so, skips calling
> transport_remove_device() and device_del(), because the starget->state
> is only set to STARGET_RUNNING after scsi_target_add() has called
> device_add() and transport_add_device().

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
