From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv3 00/14] libata: ZAC support
Date: Mon, 25 Apr 2016 16:16:27 -0400
Message-ID: <20160425201627.GI7822@mtj.duckdns.org>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461581156-92581-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Apr 25, 2016 at 12:45:42PM +0200, Hannes Reinecke wrote:
> here's a patchset implementing ZAC support for libata.
> 
> This is the second part of a larger patchset for ZAC/ZBC support;
> it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue and
> the patchset 'libata: SATL update' queued in tj/for-4.7-zac.

The patches look good from libata side.  If others are okay with it, I
can pull mkp/4.7/scsi-queue into tj/for-4.7-zac and apply this series
on top of it.

Thanks.

-- 
tejun
