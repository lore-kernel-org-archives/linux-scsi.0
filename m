From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: sg: only check for dxfer_len greater than 256M
Date: Thu, 27 Jul 2017 10:43:09 +0200
Message-ID: <4d4d2fa1-a603-a097-95ac-59e98cba795a@suse.de>
References: <20170727071126.4717-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170727071126.4717-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Jason L Tibbitts III <tibbs@math.uh.edu>, Doug Gilbert <dgilbert@interlog.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/27/2017 09:11 AM, Johannes Thumshirn wrote:
> Don't make any assumptions on the sg_io_hdr_t::dxfer_direction or the
> sg_io_hdr_t::dxferp in order to determine if it is a valid request. The
> only way we can check for bad requests is by checking if the length exceeds
> 256M.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 28676d869bbb (scsi: sg: check for valid direction before starting the
> request)
> Reported-by: Jason L Tibbitts III <tibbs@math.uh.edu>
> Tested-by: Jason L Tibbitts III <tibbs@math.uh.edu>
> Suggested-by: Doug Gilbert <dgilbert@interlog.com>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/sg.c | 31 +------------------------------
>  1 file changed, 1 insertion(+), 30 deletions(-)
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
