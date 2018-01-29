From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/19] lpfc: Allow set of maximum outstanding SCSI cmd
 limit for a target parameter
Date: Mon, 29 Jan 2018 09:08:56 +0100
Message-ID: <08c160c4-ef5b-44ce-c3eb-6d2f23d56ff5@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-10-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751355AbeA2KXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:23:16 -0500
In-Reply-To: <20180124224548.9530-10-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> Make the attribute writeable.
> Remove the ramp up to logic as its unnecessary, simply set depth.
> Add debug message if depth changed, possibly reducing limit, yet
> our outstanding count has yet to catch up with it.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c |  4 ++--
>  drivers/scsi/lpfc/lpfc_scsi.c | 39 ++++++++++++++++++++++++++++-----------
>  2 files changed, 30 insertions(+), 13 deletions(-)
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
