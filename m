From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/15] megaraid_sas: Return pended IOCTLs with cmd_status
 MFI_STAT_WRONG_STATE in case adapter is dead
Date: Fri, 30 Jun 2017 15:37:24 +0200
Message-ID: <53f86140-3eb4-806c-2026-7aa7bb94b30c@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1498811409-11157-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/30/2017 10:30 AM, Shivasharan S wrote:
> Fix - After a kill adapter, since the cmd_status is not set the
> IOCTLs will be hung in driver resulting in application hang.
> Set cmd_status MFI_STAT_WRONG_STATE when completing pended IOCTLs.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
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
