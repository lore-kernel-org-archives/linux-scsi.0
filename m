From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 09/13] be2iscsi: Remove wq_name from beiscsi_hba
Date: Thu, 22 Dec 2016 14:01:08 +0100
Message-ID: <49afef84-ca33-bfec-1687-ee6132febbe8@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-10-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752855AbcLVNBL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 08:01:11 -0500
In-Reply-To: <1481624766-13846-10-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:26 AM, Jitendra Bhivare wrote:
> wq_name is used only to set WQ name when its being allocated.
> Remove it from beiscsi_hba structure and define locally.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 9 +++++----
>  drivers/scsi/be2iscsi/be_main.h | 1 -
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
