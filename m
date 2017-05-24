From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bnx2fc: fix race condition in bnx2fc_get_host_stats()
Date: Wed, 24 May 2017 15:15:26 -0400
Message-ID: <yq17f16ukvl.fsf@oracle.com>
References: <1495627784-21048-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23626 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934210AbdEXTPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 15:15:36 -0400
In-Reply-To: <1495627784-21048-1-git-send-email-mlombard@redhat.com> (Maurizio
        Lombardi's message of "Wed, 24 May 2017 14:09:44 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com


Maurizio,

> If multiple tasks attempt to read the stats, it may happen that the
> start_req_done completion is re-initialized while still being used by
> another task, causing a list corruption.
>
> This patch fixes the bug by adding a mutex to serialize the calls to
> bnx2fc_get_host_stats().

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
