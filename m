From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv2 0/3] Initial ZAC support
Date: Wed, 5 Nov 2014 11:22:47 -0500
Message-ID: <20141105162247.GC14386@htj.dyndns.org>
References: <1415189302-108476-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415189302-108476-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 05, 2014 at 01:08:19PM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> this patchset updates the ATA stack to correctly detect
> host-managed ZAC devices.
> 
> Hannes Reinecke (3):
>   libsas: use ata_dev_classify()
>   libata: Implement ATA_DEV_ZAC
>   libata-scsi: Update SATL for ZAC drives

Applied 1-3 to libata/for-3.19.

Thanks.

-- 
tejun
