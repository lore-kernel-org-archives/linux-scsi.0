From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 25/29] be2iscsi: Fix bad WRB index error
Date: Wed, 14 Sep 2016 15:25:26 +0200
Message-ID: <b2c2f980-e896-d8d6-b846-b9ac8662aa13@suse.de>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1471600226-22055-26-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59295 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755879AbcINNZa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 09:25:30 -0400
In-Reply-To: <1471600226-22055-26-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com

On 08/19/2016 11:50 AM, Jitendra Bhivare wrote:
> In very rare scenario, connection gets killed after throwing this error:
> scsi host0: BM_2312 : Event CXN_KILLED_BAD_WRB_INDEX_ERROR[15]... CID : 4
> connection1:0: detected conn error (1011)
> 
> memset ISCSI_WRB descriptor to zero for all allocations of WRB handle.
> 
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
