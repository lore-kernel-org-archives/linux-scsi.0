From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/24] libfc: remove duplicate GPL boilerplate text
Date: Thu, 2 May 2019 08:02:36 +0200
Message-ID: <453a0b4d-d152-d2fc-4a2c-51c27ce83c71@suse.de>
References: <20190501161417.32592-1-hch@lst.de>
 <20190501161417.32592-12-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501161417.32592-12-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Willem Riede <osst@riede.org>, Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, osst-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/1/19 6:14 PM, Christoph Hellwig wrote:
> The libfc uapi headers already have proper SPDX tags, remove the
> duplicate boilerplate text.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   include/uapi/scsi/fc/fc_els.h | 13 -------------
>   include/uapi/scsi/fc/fc_fs.h  | 13 -------------
>   include/uapi/scsi/fc/fc_gs.h  | 13 -------------
>   include/uapi/scsi/fc/fc_ns.h  | 13 -------------
>   4 files changed, 52 deletions(-)
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
