From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 2/3] fcoe: separate out fcoe_vport_remove()
Date: Sun, 10 Sep 2017 10:38:23 -0700
Message-ID: <68548828-74de-0cee-8816-5e3d98a21cfd@suse.com>
References: <1504171174-37989-1-git-send-email-hare@suse.de>
 <1504171174-37989-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750869AbdIJRi2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Sep 2017 13:38:28 -0400
In-Reply-To: <1504171174-37989-3-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.com>

On 08/31/2017 02:19 AM, Hannes Reinecke wrote:
> Separate out fcoe_vport_remove() from fcoe_destroy_work().
> No functional change.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/fcoe/fcoe.c | 55 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 33 insertions(+), 22 deletions(-)
> 
> ...
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
-- 
Lee Duncan
SUSE Labs
