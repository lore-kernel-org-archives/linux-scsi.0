From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/19] lpfc: Fix SCSI io host reset causing kernel crash
Date: Mon, 29 Jan 2018 09:29:21 +0100
Message-ID: <2d7dbb4d-aee2-3f61-50dd-035cc402e4ae@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-14-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54358 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeA2KYD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:24:03 -0500
In-Reply-To: <20180124224548.9530-14-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> During SCSI error handling escalation to host reset, the SCSI io
> routines were moved off the txcmplq, but the individual io's
> ON_CMPLQ flag wasn't cleared.  Thus, a background thread saw the
> io and attempted to access it as if on the txcmplq.
> 
> Clear the flag upon removal.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |  4 ++++
>  drivers/scsi/lpfc/lpfc_sli.c  | 13 ++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
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
