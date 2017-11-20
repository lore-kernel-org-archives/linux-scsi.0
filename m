From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 01/17] lpfc: FLOGI failures are reported when connected
 to a private loop.
Date: Mon, 20 Nov 2017 14:17:29 +0100
Message-ID: <7d742ff5-1774-09b3-3dd1-697a4291a364@suse.de>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
 <20171110010834.4542-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdKTNRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 08:17:30 -0500
In-Reply-To: <20171110010834.4542-2-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/10/2017 02:08 AM, James Smart wrote:
> When the HBA is connected to a private loop, the driver
> reports FLOGI loop-open failure as functional error. This is
> an expected condition.
> 
> Mark loop-open failure as a warning instead of error.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> ---
> v2:
>   Reworked printf. v1 printed 2 messages if not a loop open failure.
>   This prints a single message if not a loop open failure. A single
>   message still exists if a loop open failure if warnings enabled.
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
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
