From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 04/13] be2iscsi: Set WRB invalid bit for SkyHawk
Date: Thu, 22 Dec 2016 13:55:33 +0100
Message-ID: <87221f02-6a6a-df36-cfb0-c8a5afc2befa@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-5-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752567AbcLVMzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 07:55:35 -0500
In-Reply-To: <1481624766-13846-5-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:25 AM, Jitendra Bhivare wrote:
> invalid bit in WRB indicates to FW that IO was invalidated before WRB
> was fetched from host memory.
>
> For SkyHawk, this invalid bit in WRB is at a different offset.
> Use amap_iscsi_wrb_v2 to mark invalid bit for SkyHawk.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 19 ++++++++++++++-----
>  drivers/scsi/be2iscsi/be_main.h |  2 +-
>  2 files changed, 15 insertions(+), 6 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
