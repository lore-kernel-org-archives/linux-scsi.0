From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/16] scsi: allocate scsi_cmnd structures as part of
 struct request
Date: Tue, 24 Jan 2017 13:57:09 +0100
Message-ID: <76d411db-299d-9b8f-ec83-e4867da4cdc8@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-14-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485185361-29786-14-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> Rely on the new block layer functionality to allocate additional driver
> specific data behind struct request instead of implementing it in SCSI
> itѕelf.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/hosts.c      |  20 +--
>  drivers/scsi/scsi.c       | 319 ----------------------------------------------
>  drivers/scsi/scsi_error.c |  17 ++-
>  drivers/scsi/scsi_lib.c   | 122 ++++++++++++------
>  drivers/scsi/scsi_priv.h  |   8 +-
>  include/scsi/scsi_host.h  |   3 -
>  6 files changed, 95 insertions(+), 394 deletions(-)
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
