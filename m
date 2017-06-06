From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] libata: factor out a ata_identify_page_supported
 helper
Date: Tue, 6 Jun 2017 08:29:56 +0200
Message-ID: <7f7a3c87-d518-f290-5c05-cd22feacb593@suse.de>
References: <20170604124225.27032-1-hch@lst.de>
 <20170604124225.27032-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170604124225.27032-5-hch@lst.de>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/04/2017 02:42 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/ata/libata-core.c | 59 +++++++++++++++++++++++++----------------------
>  1 file changed, 32 insertions(+), 27 deletions(-)
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
