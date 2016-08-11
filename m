From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/10] zfcp: trace full payload of all SAN records
 (req,resp,iels)
Date: Thu, 11 Aug 2016 13:25:42 +0200
Message-ID: <db17dcb3-0bed-b286-4049-0f370513826a@suse.de>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
 <1470846653-90691-11-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1470846653-90691-11-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/2016 06:30 PM, Steffen Maier wrote:
> This was lost with commit 2c55b750a884b86dea8b4cc5f15e1484cc47a25c
> ("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
> but is necessary for problem determination, e.g. to see the
> currently active zone set during automatic port scan.
> 
> For the large GPN_FT response (4 pages), save space by not dumping
> any empty residual entries.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: 2c55b750a884 ("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
> Cc: <stable@vger.kernel.org> #2.6.38+
> Reviewed-by: Alexey Ishchuk <aishchuk@linux.vnet.ibm.com>
> Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_dbf.c | 116 ++++++++++++++++++++++++++++++++++++++-----
>  drivers/s390/scsi/zfcp_dbf.h |   1 +
>  2 files changed, 104 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Despite the _really_ ugly if() statement...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
