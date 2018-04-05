From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/3] Revert "scsi: core: return BLK_STS_OK for
        DID_OK in __scsi_error_from_host_byte()"
Date: Thu, 5 Apr 2018 19:34:32 +0200
Message-ID: <20180405173432.GA11009@lst.de>
References: <20180405173301.13186-1-bart.vanassche@wdc.com> <20180405173301.13186-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405173301.13186-2-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Douglas Gilbert <dgilbert@interlog.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>, Lee Duncan <lduncan@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
