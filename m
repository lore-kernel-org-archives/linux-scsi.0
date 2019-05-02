From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 23/24] st: add a SPDX tag to st.c
Date: Thu, 2 May 2019 08:06:23 +0200
Message-ID: <d488ea80-ed62-ab0b-0e6e-48e14b1e1027@suse.de>
References: <20190501161417.32592-1-hch@lst.de>
 <20190501161417.32592-24-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501161417.32592-24-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Willem Riede <osst@riede.org>, Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, osst-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/1/19 6:14 PM, Christoph Hellwig wrote:
> st.c is the only st file missing licensing information.  Add a
> GPLv2 tag for the default kernel license.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/st.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 19c022e66d63..b814906af0a3 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>   /*
>      SCSI Tape Driver for Linux version 1.1 and newer. See the accompanying
>      file Documentation/scsi/st.txt for more information.
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
