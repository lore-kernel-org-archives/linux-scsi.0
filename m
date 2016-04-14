From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv2 09/14] libata: fixup ZAC device disabling
Date: Thu, 14 Apr 2016 11:43:55 -0400
Message-ID: <20160414154355.GC12583@htj.duckdns.org>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-10-git-send-email-hare@suse.de>
 <20160413180947.GF3676@htj.duckdns.org>
 <570F2F13.2040509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570F2F13.2040509@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 14, 2016 at 07:48:03AM +0200, Hannes Reinecke wrote:
> On 04/13/2016 08:09 PM, Tejun Heo wrote:
> > On Tue, Apr 12, 2016 at 08:47:53AM +0200, Hannes Reinecke wrote:
> >> libata device disabling is ... curious. So add the correct
> >> definitions that we can disable ZAC devices properly.
> > 
> > Fold into an earlier patch?
> > 
> That earlier patch would be commit
> 9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb
> ("libata: Implement ATA_DEV_ZAC"), which got merged
> in 2014 ...

Ah, right you are.

Thanks.

-- 
tejun
