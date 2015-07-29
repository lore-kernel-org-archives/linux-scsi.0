From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 4/8] pm80xx: Fix for Incorrect DMA Unmapping of SG List
Date: Wed, 29 Jul 2015 18:12:16 +0200
Message-ID: <55B8FB60.7040307@redhat.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
 <1438151240-4097-5-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbbG2QMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 12:12:18 -0400
In-Reply-To: <1438151240-4097-5-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com

On 29.7.2015 08:27, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
> 
> In pm8001_ccb_task_free(), the dma unmapping is done based on
> ccb->n_elem value. This should be initialized to zero in the
> task_abort(). Otherwise, pm8001_ccb_task_free() will try for
> dma_unmap_sg() which is invalid for task abort and can lead to
> kernel crash.
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

