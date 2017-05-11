From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/15] lpfc: Fix system crash when port is reset.
Date: Thu, 11 May 2017 08:05:26 +0200
Message-ID: <f64876d0-0087-366d-e214-1082616863c3@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-3-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41142 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751028AbdEKGF3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 02:05:29 -0400
In-Reply-To: <20170510190713.30171-3-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> The driver panic when using the els_wq during port reset.
> 
> Check for NULL els_wq before dereferencing.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h         | 8 ++++++--
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 6 +++---
>  2 files changed, 9 insertions(+), 5 deletions(-)
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
