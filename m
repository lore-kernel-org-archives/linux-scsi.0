From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 3/8] megaraid_sas: Do not fire DCMDs during PCI
 shutdown/detach
Date: Mon, 24 Oct 2016 16:34:30 +0200
Message-ID: <23dda6c4-bd22-e4e8-f272-3ebf7a67182f@suse.de>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
 <1477056816-7058-4-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751292AbcJXOed (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 10:34:33 -0400
In-Reply-To: <1477056816-7058-4-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>

On 10/21/2016 03:33 PM, Kashyap Desai wrote:
> This patch addresses the issue of driver firing DCMDs in PCI
> shutdown/detach path irrespective of firmware state.
> Driver will check for whether firmware is operational state or not
> before firing DCMDs. If firmware is in unrecoverbale
> state or does not become operational within specfied time, driver will
> skip firing DCMDs.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Signed-off-by: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 39 +++++++++++++++++++++++++++++
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  9 ++++---
>  2 files changed, 45 insertions(+), 3 deletions(-)
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
