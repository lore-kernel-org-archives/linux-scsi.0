From: Ankit Jain <jankit@suse.de>
Subject: Re: [PATCH] libsas: export sas_alloc_task()
Date: Sat, 28 May 2011 19:24:19 +0530
Message-ID: <4DE0FE8B.3090603@suse.de>
References: <20110528010202.13696.25504.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52449 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab1E1NxA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2011 09:53:00 -0400
In-Reply-To: <20110528010202.13696.25504.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, Lindar Liu <lindar_liu@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, Jack Wang <jack_wang@usish.com>

On 05/28/2011 06:32 AM, Dan Williams wrote:
> Before isci adds a 3rd open coded user of this functionality just share
> the libsas version.
> 
> Cc: Jack Wang <jack_wang@usish.com>
> Cc: Lindar Liu <lindar_liu@usish.com>
> Cc: Xiangliang Yu <yuxiangl@marvell.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_init.c   |   27 ++++++++++++++++++++++++++-
>  drivers/scsi/mvsas/mv_sas.c      |   28 +++-------------------------
>  drivers/scsi/pm8001/pm8001_sas.c |   36 ++++++------------------------------
>  include/scsi/libsas.h            |   26 ++------------------------
>  4 files changed, 37 insertions(+), 80 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 2dc5534..408a46b 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c

Comments in include/linux/slab.h suggest that KMEM_CACHE macro should be
used now instead of kmem_cache_create. Since you are touching this code
anyway, might as well fix that (in sas_class_init).

Thanks,
-- 
Ankit Jain
SUSE Labs
