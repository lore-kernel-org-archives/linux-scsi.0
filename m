From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 01/12] Avoid that scsi_exit_rq() triggers a
        use-after-free
Date: Fri, 2 Jun 2017 09:16:04 +0200
Message-ID: <20170602071604.GA560@lst.de>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com> <20170601232711.29062-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601232711.29062-2-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Scott Bauer <scott.bauer@intel.com>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
