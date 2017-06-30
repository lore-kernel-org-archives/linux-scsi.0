From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/15] megaraid_sas: use vmalloc for crash dump buffers
 and driver's local RAID map
Date: Fri, 30 Jun 2017 15:36:24 +0200
Message-ID: <37f51a1e-ffb1-a45c-4724-ca73deb28842@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38067 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751690AbdF3Ngc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:36:32 -0400
In-Reply-To: <1498811409-11157-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 06/30/2017 10:30 AM, Shivasharan S wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |   1 -
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  12 ++-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 113 +++++++++++++++++-----------
>  3 files changed, 80 insertions(+), 46 deletions(-)
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
