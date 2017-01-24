From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Tue, 24 Jan 2017 13:10:17 +0100
Message-ID: <20170124121017.GE3609@linux-x5ow.site>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
 <20170123163446.9227-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170123163446.9227-2-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Michael Hernandez <michael.hernandez@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 23, 2017 at 08:34:45AM -0800, Bart Van Assche wrote:
> qla2x00_probe_one() allocates IRQs before it initializes rsp_q_map
> so IRQs must be freed even if rsp_q_map allocation did not occur.
> This was detected by kmemleak.
> 
> Fixes: 4fa183455988 ("scsi: qla2xxx: Utilize pci_alloc_irq_vectors/pci_free_irq_vectors calls")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Michael Hernandez <michael.hernandez@cavium.com>
> Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
