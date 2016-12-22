From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 12/13] be2iscsi: Add warning message for unsupported
 adapter
Date: Thu, 22 Dec 2016 14:06:07 +0100
Message-ID: <38eb6be2-e849-11e3-2f58-0676c9bd0b76@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-13-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934354AbcLVNGS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 08:06:18 -0500
In-Reply-To: <1481624766-13846-13-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Ketan Mukadam <ketan.mukadam@avagotech.com>

On 12/13/2016 11:26 AM, Jitendra Bhivare wrote:
> From: Ketan Mukadam <ketan.mukadam@avagotech.com>
>
> Add a warning message to indicate obsolete/unsupported
> BE2 Adapter Family devices
>
> Signed-off-by: Ketan Mukadam <ketan.mukadam@avagotech.com>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 2 ++
>  drivers/scsi/be2iscsi/be_mgmt.c | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
