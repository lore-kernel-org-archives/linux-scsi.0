From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 15/17] lpfc: Synchronize link speed with boot driver
Date: Fri, 14 Oct 2016 12:43:35 +0200
Message-ID: <b3406468-da29-e93a-d915-6ead33149404@suse.de>
References: <58000558.oQvh2S/jqBX/2X/s%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46194 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754194AbcJNKni (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 06:43:38 -0400
In-Reply-To: <58000558.oQvh2S/jqBX/2X/s%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Synchronize link speed with boot driver
> 
> Link speed settings set by the boot driver are reported by the hw.
> Driver will attempt to read them, and if set, will respect their
> values.
> The driver can override the settings with its own if instructed by
> user space (via bsg), with the new values being picked up by the
> boot driver.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
> v3 mods:
>  parens cleanup
>  use shost_priv() on new code
> 
>  drivers/scsi/lpfc/lpfc.h      |  4 ++++
>  drivers/scsi/lpfc/lpfc_attr.c |  7 +++++-
>  drivers/scsi/lpfc/lpfc_bsg.c  | 45 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_bsg.h  | 10 ++++++++
>  drivers/scsi/lpfc/lpfc_hw4.h  |  3 +++
>  drivers/scsi/lpfc/lpfc_init.c | 54 +++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 122 insertions(+), 1 deletion(-)
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
