From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv2 05/14] libata: NCQ Encapsulation for READ LOG DMA EXT
Date: Thu, 14 Apr 2016 11:43:38 -0400
Message-ID: <20160414154338.GB12583@htj.duckdns.org>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-6-git-send-email-hare@suse.de>
 <20160413180735.GD3676@htj.duckdns.org>
 <570F2E33.3080709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570F2E33.3080709@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Hannes.

On Thu, Apr 14, 2016 at 07:44:19AM +0200, Hannes Reinecke wrote:
> Hehe. No, it isn't, if you look closely.
> (Or make that: it _shouldn't_, and I've messed it up)
> (That's what the 'fpdma' parameter is for)
> 
> The benefit is not so much for normal operations, but it'll give us
> a performance improvements on SMR drives where we need to issue
> READ LOG DMA EXT rather frequently. There we really want to have
> them as NCQ commands.

I'm still a bit confused.  Isn't it part of EH?  If so, the path is
never traveled with other commands in flight and thus whether a
command is NCQ or not doesn't make any difference.  The only thing
it'd do is making devices which advertise the capability but don't get
it quite right fail.

Thanks.

-- 
tejun
