From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 9/9] zfcp: decouple our scsi_eh callbacks from scsi_cmnd
Date: Wed, 26 Jul 2017 08:16:42 +0200
Message-ID: <7a91a979-cb1b-00e9-9ae9-6c63ce9456fe@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-10-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51167 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750768AbdGZGQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 02:16:44 -0400
In-Reply-To: <20170725141427.35258-10-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> zfcp_scsi_eh_device_reset_handler() now only depends on scsi_device.
> zfcp_scsi_eh_target_reset_handler() now only depends on scsi_target.
> zfcp_scsi_eh_host_reset_handler() now only depends on Scsi_Host.
> All derive other objects from these intended callback arguments.
> 
> Actually change the signature of zfcp_task_mgmt_function() used by
> zfcp_scsi_eh_device_reset_handler() & zfcp_scsi_eh_target_reset_handler().
> Since it was prepared in a previous patch, we only need to delete
> some local auto variables which are now the intended arguments.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_scsi.c | 40 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 8 deletions(-)
> 
Thank you for doing this.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
