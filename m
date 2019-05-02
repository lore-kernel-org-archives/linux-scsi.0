From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/24] libiscsi: switch to SPDX tags
Date: Thu, 2 May 2019 08:03:46 +0200
Message-ID: <a47855d7-edc9-bb2b-21df-4fc0ca5f2735@suse.de>
References: <20190501161417.32592-1-hch@lst.de>
 <20190501161417.32592-15-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501161417.32592-15-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Willem Riede <osst@riede.org>, Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, osst-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/1/19 6:14 PM, Christoph Hellwig wrote:
> Use the the GPLv2+ SPDX tag instead of verbose boilerplate text.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/libiscsi.c       | 15 +--------------
>   drivers/scsi/libiscsi_tcp.c   | 13 +------------
>   include/scsi/iscsi_if.h       | 13 +------------
>   include/scsi/iscsi_proto.h    | 13 +------------
>   include/scsi/libiscsi.h       | 15 +--------------
>   include/scsi/libiscsi_tcp.h   | 13 +------------
>   include/scsi/scsi_bsg_iscsi.h | 16 +---------------
>   7 files changed, 7 insertions(+), 91 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
