From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/10] be2iscsi: driver update 11.4.0.0
Date: Mon, 27 Mar 2017 22:04:40 -0400
Message-ID: <yq1vaqu5f7r.fsf@oracle.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31421 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753683AbdC1CFy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2017 22:05:54 -0400
In-Reply-To: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
        (Jitendra Bhivare's message of "Fri, 24 Mar 2017 14:11:39 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: thenzl@redhat.com, cleech@redhat.com, lduncan@suse.com, linux-scsi@vger.kernel.org

Jitendra Bhivare <jitendra.bhivare@broadcom.com> writes:

> This patch is generated against for-next branch.
>
> v3 changes:
>  be2iscsi: Fix closing of connection
>  	- Fixed per Tomas's review comments.
>
> v2 changes:
>  +be2iscsi: Update Copyright
>
> Jitendra Bhivare (10):
>   be2iscsi: Check tag in beiscsi_mccq_compl_wait
>   be2iscsi: Fix closing of connection
>   be2iscsi: Replace spin_unlock_bh with spin_lock
>   scsi_transport_iscsi: Use flush_work in iscsi_remove_session
>   be2iscsi: Increase HDQ default queue size
>   be2iscsi: Use num_cons field in Rx CQE
>   be2iscsi: Remove free_list for ASYNC handles
>   be2iscsi: Check size before copying ASYNC handle
>   be2iscsi: Update Copyright
>   be2iscsi: Update driver version

Applied to 4.12/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
