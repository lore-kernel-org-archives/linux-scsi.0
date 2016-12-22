From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 10/13] be2iscsi: Add checks to validate CID alloc/free
Date: Thu, 22 Dec 2016 14:03:50 +0100
Message-ID: <a64f8142-1271-3d6b-4b13-dae87c607b72@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-11-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42005 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757527AbcLVNEc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 08:04:32 -0500
In-Reply-To: <1481624766-13846-11-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:26 AM, Jitendra Bhivare wrote:
> Set CID slot to 0xffff to indicate empty.
> Check if connection already exists in conn_table before binding.
> Check if endpoint already NULL before putting back CID.
> Break ep->conn link in free_ep to ignore completions after freeing.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_iscsi.c | 163 ++++++++++++++++++++-------------------
>  drivers/scsi/be2iscsi/be_main.c  |   7 +-
>  drivers/scsi/be2iscsi/be_main.h  |   1 +
>  3 files changed, 87 insertions(+), 84 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
