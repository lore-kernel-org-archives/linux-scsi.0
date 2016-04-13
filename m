From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv2 05/14] libata: NCQ Encapsulation for READ LOG DMA EXT
Date: Wed, 13 Apr 2016 14:07:35 -0400
Message-ID: <20160413180735.GD3676@htj.duckdns.org>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460443678-57934-6-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 12, 2016 at 08:47:49AM +0200, Hannes Reinecke wrote:
> Recent devices can use NCQ encapsulation for READ LOG DMA EXT,
> so we should be using it if available.

Does this have any actual benefits than being new and shiny?  It's
being called from EH path where we know that no other commands are in
flight.

Thanks.

-- 
tejun
