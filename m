From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH/RFC] SCSI mid-layer suspend/resume
Date: Mon, 24 Oct 2005 22:55:38 -0400
Message-ID: <435D9EAA.9040406@rtr.ca>
References: <20051024160531.7d879a7c.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051024160531.7d879a7c.randy_d_dunlap@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, axboe@suse.de, jgarzik@pobox.com, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

Randy Dunlap wrote:
> RFC.
> 
> Although Jens's SATA suspend/resume patch works, it seems that the
> SCSI maintainer(s) want something different, e.g., Nathan Bryant's
> 2004 patch[1] with some changes:
...
> Mark Lord:  where is the GFP_KERNEL usage that you were concerned
>   about on resume? [7]

Seems to be gone now in 2.6.14-rc*.
Not an issue now.
