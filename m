From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 01/13] be2iscsi: Fix use of invalidate command table
 req
Date: Thu, 22 Dec 2016 13:51:29 +0100
Message-ID: <1403d528-7f35-c41e-f7e8-c5bf62f5828e@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-2-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41067 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752092AbcLVMvc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 07:51:32 -0500
In-Reply-To: <1481624766-13846-2-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:25 AM, Jitendra Bhivare wrote:
> Remove shared structure inv_tbl in phba for all sessions to post
> invalidation IOCTL.
> Always allocate and then free the table after use in reset handler.
> Abort handler needs just one instance so define it on stack.
> Add checks for BE_INVLDT_CMD_TBL_SZ to not exceed invalidation
> command table size in IOCTL.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 85 ++++++++++++++++++++++++-----------------
>  drivers/scsi/be2iscsi/be_main.h | 16 ++++----
>  drivers/scsi/be2iscsi/be_mgmt.c | 12 +++---
>  drivers/scsi/be2iscsi/be_mgmt.h | 40 +++++++++----------
>  4 files changed, 83 insertions(+), 70 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
