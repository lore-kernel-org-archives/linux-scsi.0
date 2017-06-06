From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] sd: add support for TCG OPAL self encrypting disks
Date: Tue, 6 Jun 2017 08:31:30 +0200
Message-ID: <f626c9f5-ef7d-6cb6-1272-baf2db692d3a@suse.de>
References: <20170604124225.27032-1-hch@lst.de>
 <20170604124225.27032-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170604124225.27032-7-hch@lst.de>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/04/2017 02:42 PM, Christoph Hellwig wrote:
> Just wire up the generic TCG OPAL infrastructure to the SCSI disk driver
> and the Security In/Out commands.
> 
> Note that I don't know of any actual SCSI disks that do support TCG OPAL,
> but this is required to support ATA disks through libata.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/sd.h |  2 ++
>  2 files changed, 46 insertions(+)
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
