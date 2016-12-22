From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 05/13] be2iscsi: Add checks to validate completions
Date: Thu, 22 Dec 2016 13:56:31 +0100
Message-ID: <c654f2a6-1788-23e7-85ef-0c3996886b96@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-6-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41418 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752567AbcLVM4d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 07:56:33 -0500
In-Reply-To: <1481624766-13846-6-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:25 AM, Jitendra Bhivare wrote:
> Added check in beiscsi_process_cq for pio_handle.
> pio_handle is cleared in beiscsi_put_wrb_handle.
> This catches any case where task gets cleaned up just before completion.
>
> Use back_lock before accessing pio_handle.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
