From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/15] lpfc: Fix NVMEI's handling of NVMET's PRLI response
 attributes
Date: Thu, 11 May 2017 09:50:32 +0200
Message-ID: <b39d44a4-3fc0-2fc6-90ee-bef846dd9247@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-14-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47377 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753133AbdEKHue (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 03:50:34 -0400
In-Reply-To: <20170510190713.30171-14-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> Code review of NVMEI's FC_PORT_ROLE_NVME_DISCOVERY
> looked wrong.
> 
> Discussions with storage architecture team clarified
> NVMEI's audit of the PRLI response port roles.  Following up
> discussion with code review showed a few minor corrections
> were required - especially in anticipation of NVME auto
> discovery.
> 
> During PRLI, NVMEI should sent prli_init - which it it
> does.  NVMET should send prli_tgt and prli_disc - which it does.
> When NVMEI receives a PRLI Response now, it audits the
> incoming target bits and stores the attributes in the
> corresponding NDLP.  Later, when NVMEI registers the NVME
> rport, it uses the stored ndlp attributes to set the rport
> port_roles correctly.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_disc.h      | 1 +
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++++
>  2 files changed, 7 insertions(+)
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
