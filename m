From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/16] scsi: remove __scsi_alloc_queue
Date: Tue, 24 Jan 2017 12:08:25 +0100
Message-ID: <05d9c12c-6899-ea99-2781-6fc7ecf5528a@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-13-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485185361-29786-13-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> Instead do an internal export of __scsi_init_queue for the transport
> classes that export BSG nodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_lib.c             | 19 ++++---------------
>  drivers/scsi/scsi_transport_fc.c    |  6 ++++--
>  drivers/scsi/scsi_transport_iscsi.c |  3 ++-
>  include/scsi/scsi_host.h            |  2 --
>  include/scsi/scsi_transport.h       |  2 ++
>  5 files changed, 12 insertions(+), 20 deletions(-)
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
