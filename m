From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Revert "scsi: default to scsi-mq"
Date: Mon, 14 Aug 2017 08:23:33 +0200
Message-ID: <a86e5829-8292-9aa1-c354-54b27c0abb17@suse.de>
References: <20170813174422.16197-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170813174422.16197-1-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/13/2017 07:44 PM, Christoph Hellwig wrote:
> Defaulting to scsi-mq in 4.13-rc has shown various regressions
> on setups that we didn't previously consider.  Fixes for them are
> in progress, but too invasive to make it in this cycle.  So for
> now revert the commit that defaults to blk-mq for SCSI.  For 4.14
> we'll plan to try again with these fixes.
> 
> This reverts commit 5c279bd9e40624f4ab6e688671026d6005b066fa.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
