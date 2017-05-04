From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Thu, 4 May 2017 09:30:13 +0200
Message-ID: <20170504073013.GA3684@lst.de>
References: <20170503180911.24326-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170503180911.24326-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Scott Bauer <scott.bauer@intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Please just add a flag to ->flags instead of adding a whole new field.

Otherwise this looks good to me.
