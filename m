From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] MAINTAINERS: Move FCoE to Hannes Reinecke
Date: Mon, 28 Jan 2019 12:37:56 +0100
Message-ID: <049182df-4bfa-a93f-3773-0a9789516c2b@suse.de>
References: <20190128110634.17243-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128110634.17243-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1/28/19 12:06 PM, Johannes Thumshirn wrote:
> I'll be moving on to different things in the storage stack and Hannes
> agreed to take over FCoE.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9f64f8d3740e..49b829794699 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5855,7 +5855,7 @@ S:	Maintained
>   F:	drivers/media/tuners/fc2580*
>   
>   FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
> -M:	Johannes Thumshirn <jth@kernel.org>
> +M:	Hannes Reinecke <hare@suse.de>
>   L:	linux-scsi@vger.kernel.org
>   W:	www.Open-FCoE.org
>   S:	Supported
> 
Acked-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
