From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 12/17] lpfc: correct port registrations with nvme_fc
Date: Mon, 20 Nov 2017 14:26:33 +0100
Message-ID: <93551709-5bfc-1da6-e789-5d1a4357678e@suse.de>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
 <20171110010834.4542-13-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57251 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbdKTN0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 08:26:35 -0500
In-Reply-To: <20171110010834.4542-13-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/10/2017 02:08 AM, James Smart wrote:
> The driver currently registers any remote port that has NVME support.
> It should only be registering target ports.
> 
> Register only target ports.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 20 ++++++++++++--------
>  drivers/scsi/lpfc/lpfc_nvme.c    |  3 ++-
>  2 files changed, 14 insertions(+), 9 deletions(-)
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
