From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/17] lpfc: Adjust default value of lpfc_nvmet_mrq
Date: Wed, 8 Nov 2017 10:38:36 +0100
Message-ID: <4eb42318-ece6-43ff-1a5e-5f866dabe47c@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-10-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751676AbdKHJii (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 04:38:38 -0500
In-Reply-To: <20171103225628.24716-10-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/03/2017 11:56 PM, James Smart wrote:
> The current default for async hw receive queues is 1, which presents
> issues under heavy load as number of queues influence the available
> async receive buffer limits.
> 
> Raise the default to the either the current hw limit (16) or the number
> of hw qs configured (io channel value).
> 
> Revise the attribute definition for mrq to better reflect what we do
> for hw queues. E.g. 0 means default to optimal (# of cpus), non-zero
> specifies a specific limit. Before this change, mrq=0 meant target
> mode was disabled. As 0 now has a different meaning, rework the
> if tests to use the better nvmet_support check.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c    | 11 ++++++++--
>  drivers/scsi/lpfc/lpfc_debugfs.c |  2 +-
>  drivers/scsi/lpfc/lpfc_init.c    | 47 ++++++++++++++++++++++++----------------
>  drivers/scsi/lpfc/lpfc_nvmet.h   |  4 ++++
>  4 files changed, 42 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
