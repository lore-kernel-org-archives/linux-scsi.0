From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH  2.6.11-rc4+] sata_qstor: new basic driver for Pacific
 Digital QStor
Date: Thu, 17 Feb 2005 01:14:27 -0500
Message-ID: <42143643.7030706@pobox.com>
References: <4214313E.5060900@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4214313E.5060900@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> This is a new basic libata SATA driver
> for the Pacific Digital QStor SATA/RAID card.
> 
> It features ordinary per-drive SATA with single-request DMA
> for R/W commands, and PIO for everything else.
> 
> It currently does not implement any of the hardware RAID support,
> nor hot-plug, nor the tagged/native command-queuing features.
> 
> On the other hand, it is small and simple as a result.
> 
> Patch is against 2.6.11-rc4 + minor libata updates from Jeff.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>

Thanks, I'll suck this into the pipeline.

For any comments/changes that arise, please send patches incremental to 
this patch.

	Jeff



