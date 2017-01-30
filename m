From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] libsas: remove sas_scsi_timed_out
Date: Mon, 30 Jan 2017 16:29:47 +0100
Message-ID: <1a9bda53-6160-16e6-9b86-c3a785d440be@suse.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
 <1485778739-29036-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41703 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753675AbdA3Par (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 10:30:47 -0500
In-Reply-To: <1485778739-29036-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 01/30/2017 01:18 PM, Christoph Hellwig wrote:
> EH_NOT_HANDLED is the default case if no eh_timed_out method is provided,
> so there is no need to supply it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/libsas/sas_init.c      | 1 -
>  drivers/scsi/libsas/sas_internal.h  | 2 --
>  drivers/scsi/libsas/sas_scsi_host.c | 7 -------
>  3 files changed, 10 deletions(-)
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
