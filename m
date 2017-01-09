From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] pmcraid: switch to pci_alloc_irq_vectors
Date: Mon, 9 Jan 2017 10:54:35 +0100
Message-ID: <871f8035-e24e-1267-2390-76805f8ed3dc@suse.de>
References: <1479450496-14331-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42589 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754876AbdAIJzr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Jan 2017 04:55:47 -0500
In-Reply-To: <1479450496-14331-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 11/18/2016 07:28 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/pmcraid.c | 92 ++++++++++++++++++++++----------------------------
>  drivers/scsi/pmcraid.h |  1 -
>  2 files changed, 41 insertions(+), 52 deletions(-)
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
