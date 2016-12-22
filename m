From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 11/13] be2iscsi: Reinit SGL handle, CID tables after
 TPE
Date: Thu, 22 Dec 2016 14:05:07 +0100
Message-ID: <7f4245c8-8e87-317c-3211-4ddb8cdb11df@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-12-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42069 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757527AbcLVNFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 08:05:10 -0500
In-Reply-To: <1481624766-13846-12-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:26 AM, Jitendra Bhivare wrote:
> After TPE recovery, CID table needs to be repopulated as per CIDs in
> WRBQ creation responses.
>
> SGL handles table needs to be recreated for posting and its indices need
> to be resetted.
>
> This is achieved by calling beiscsi_cleanup_port when disabling and
> beiscsi_init_port in enabling port.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 61 ++++++++++++++---------------------------
>  1 file changed, 20 insertions(+), 41 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
