From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 3/4] target: Return descriptor format sense data in
 case the LU spans 64bit sectors
Date: Wed, 15 Jul 2015 01:29:53 -0700
Message-ID: <20150715082953.GC6684@infradead.org>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com>
 <1436946939-19415-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436946939-19415-4-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 15, 2015 at 10:55:38AM +0300, Sagi Grimberg wrote:
> In case a LU spans 64bit sectors, fixed size sense data information
> field is only 32 bits which means the sector information will be truncated.
> 
> Thus, if the LU spans 64bit sectors, use descriptor format sense data to
> correctly report sector information.
> 
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
