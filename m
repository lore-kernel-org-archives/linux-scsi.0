From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/6] sd: improve TUR handling in sd_check_events
Date: Wed, 15 Feb 2017 09:00:45 +0100
Message-ID: <235244db-9821-b6b8-7926-e937a06d25d6@suse.de>
References: <20170214191600.17480-1-hch@lst.de>
 <20170214191600.17480-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170214191600.17480-3-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernek.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/14/2017 08:15 PM, Christoph Hellwig wrote:
> Remove bogus evaluations of retval and sshdr when the device is offline,
> and fix a possible NULL pointer dereference by allocating the 8 byte
> sized sense header on stack.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
