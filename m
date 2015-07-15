From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 2/4] scsi: Protect against buffer possible overflow in
 scsi_set_sense_information
Date: Wed, 15 Jul 2015 01:29:21 -0700
Message-ID: <20150715082921.GB6684@infradead.org>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com>
 <1436946939-19415-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436946939-19415-3-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 15, 2015 at 10:55:37AM +0300, Sagi Grimberg wrote:
> Make sure that the input sense buffer has sufficient length
> to fit the information descriptor (12 additional bytes).
> Modify scsi_set_sense_information to receive the sense buffer
> length and adjust its callers scsi target and libata.
> 
> Reported-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Tejun Heo <tj@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
