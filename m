From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] libata: implement SECURITY PROTOCOL IN/OUT
Date: Tue, 6 Jun 2017 08:30:50 +0200
Message-ID: <72baa72f-92f1-977a-7854-692c21f949b3@suse.de>
References: <20170604124225.27032-1-hch@lst.de>
 <20170604124225.27032-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170604124225.27032-6-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/04/2017 02:42 PM, Christoph Hellwig wrote:
> This allows us to use the generic OPAL code with ATA devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/ata/libata-core.c | 32 ++++++++++++++++++++
>  drivers/ata/libata-scsi.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/ata.h       |  1 +
>  include/linux/libata.h    |  1 +
>  4 files changed, 110 insertions(+)
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
