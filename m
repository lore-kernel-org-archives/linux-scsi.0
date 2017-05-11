From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/15] lpfc: Adding additional stats counters for nvme.
Date: Thu, 11 May 2017 08:06:27 +0200
Message-ID: <0b3bd7fb-2897-dfb2-3c87-8ed7e581ab56@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-4-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41214 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751749AbdEKGG3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 02:06:29 -0400
In-Reply-To: <20170510190713.30171-4-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> More debug messages added for nvme statistics.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c    | 24 ++++++++++++---------
>  drivers/scsi/lpfc/lpfc_debugfs.c | 27 +++++++++++++----------
>  drivers/scsi/lpfc/lpfc_nvmet.c   | 46 ++++++++++++++++++++++++++++++----------
>  drivers/scsi/lpfc/lpfc_nvmet.h   | 12 ++++++-----
>  drivers/scsi/lpfc/lpfc_sli.c     | 38 ++++++++++++++++++++++++++++-----
>  drivers/scsi/lpfc/lpfc_sli4.h    |  2 +-
>  6 files changed, 106 insertions(+), 43 deletions(-)
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
