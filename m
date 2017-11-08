From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/17] lpfc: Fix display for debugfs queInfo
Date: Wed, 8 Nov 2017 10:26:16 +0100
Message-ID: <25e0b900-6f63-332f-773d-b8cf380c9982@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-9-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57595 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751122AbdKHJ0S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 04:26:18 -0500
In-Reply-To: <20171103225628.24716-9-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/03/2017 11:56 PM, James Smart wrote:
> Display for lpfc/fnX/iDiag/queInfo isn't formatted perfectly.
> Corrected the format strings for the queue info debug messages.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
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
