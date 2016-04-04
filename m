From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/14] libata-scsi: sanitize ata_gen_ata_sense()
Date: Mon, 4 Apr 2016 12:22:53 -0400
Message-ID: <20160404162253.GZ7822@mtj.duckdns.org>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
 <1459763047-125551-4-git-send-email-hare@suse.de>
 <57024F7B.20604@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57024F7B.20604@cogentembedded.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 04, 2016 at 02:26:51PM +0300, Sergei Shtylyov wrote:
> >+	} else {
> >+		/* Could not decode error */
> >+		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",
> 
>    "%#x" is equivalent and takes up less space.

Oops, gmail for some reason put Sergei's messages into spam folder.
Hannes, can you please generate incremental patches for Sergei's
comments?

Thanks.

-- 
tejun
