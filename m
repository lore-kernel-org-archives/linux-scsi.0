From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] sg: protect access to to 'reserved' page array
Date: Wed, 1 Feb 2017 12:23:36 +0100
Message-ID: <20170201112335.GB3661@linux-x5ow.site>
References: <1485948135-83249-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485948135-83249-1-git-send-email-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 01, 2017 at 12:22:15PM +0100, Hannes Reinecke wrote:
> The 'reserved' page array is used as a short-cut for mapping
> data, saving us to allocate pages per request.
> However, the 'reserved' array is only capable of holding one
> request, so we need to protect it against concurrent accesses.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Link: http://www.spinics.net/lists/linux-scsi/msg104326.html
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Tested-by: Johannes Thumshirn <jth@kernel.org>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
