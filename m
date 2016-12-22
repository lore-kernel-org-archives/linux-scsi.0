From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 08/13] be2iscsi: Remove unused struct members
Date: Thu, 22 Dec 2016 13:59:09 +0100
Message-ID: <7fbb0902-1c54-c42f-aa55-4c8cb26556eb@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-9-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41520 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752855AbcLVNAE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 08:00:04 -0500
In-Reply-To: <1481624766-13846-9-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:26 AM, Jitendra Bhivare wrote:
> Fix errors reported in static analysis.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be.h       |  3 --
>  drivers/scsi/be2iscsi/be_cmds.c  |  8 +++---
>  drivers/scsi/be2iscsi/be_cmds.h  | 17 ++++++------
>  drivers/scsi/be2iscsi/be_iscsi.c |  2 +-
>  drivers/scsi/be2iscsi/be_main.c  | 24 +++-------------
>  drivers/scsi/be2iscsi/be_main.h  | 22 ---------------
>  drivers/scsi/be2iscsi/be_mgmt.c  |  9 ++----
>  drivers/scsi/be2iscsi/be_mgmt.h  | 60 ----------------------------------------
>  8 files changed, 21 insertions(+), 124 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
