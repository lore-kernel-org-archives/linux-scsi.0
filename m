From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 04/16] lpfc: refactor debugfs queue prints
Date: Mon, 13 Feb 2017 09:32:57 +0100
Message-ID: <c8f1e00a-974a-8e65-4a64-f5fcbe1af0dc@suse.de>
References: <58a0d91c.FMlII2L+0d4RFlSj%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37049 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752487AbdBMIc7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 03:32:59 -0500
In-Reply-To: <58a0d91c.FMlII2L+0d4RFlSj%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> Create common wq, cq, eq, rq print functions
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h         |   1 +
>  drivers/scsi/lpfc/lpfc_debugfs.c | 564 ++++++++++++++++-----------------------
>  2 files changed, 228 insertions(+), 337 deletions(-)
> 
One should look at converting it to seq_file(), seeing that there are
provisions for overflow already.
But that can be done in a later patch.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
