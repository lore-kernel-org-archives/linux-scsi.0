From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 1/4] scsi: Fix wrong additional sense length in
 descriptor format
Date: Wed, 15 Jul 2015 01:27:49 -0700
Message-ID: <20150715082749.GA6684@infradead.org>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com>
 <1436946939-19415-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436946939-19415-2-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 15, 2015 at 10:55:36AM +0300, Sagi Grimberg wrote:
> The sense header additional sense length should be the accumulated
> size of all the descriptors. Information descriptor size is 12 bytes.
> When setting the additional sense length we should add 0xc instead of
> 0xa.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
