From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 06/13] be2iscsi: Fix iSCSI cmd cleanup IOCTL
Date: Thu, 22 Dec 2016 13:57:20 +0100
Message-ID: <99d842ed-111f-6651-79cf-5996dba5bc14@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-7-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41444 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756141AbcLVM5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 07:57:22 -0500
In-Reply-To: <1481624766-13846-7-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:25 AM, Jitendra Bhivare wrote:
> Prepare the IOCTL with appropriate sizes of buffers of V0 and V1.
> Set missing chute number in V1 IOCTL.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c | 33 ++++++++++++++++++---------------
>  drivers/scsi/be2iscsi/be_main.c |  3 +--
>  2 files changed, 19 insertions(+), 17 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
