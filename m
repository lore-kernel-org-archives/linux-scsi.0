From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Warning: about not setting max_sectors
Date: Wed, 11 Dec 2002 10:57:47 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021211105747.A32363@infradead.org>
References: <hch@infradead.org> <200212101447.gBAElpJ01949@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200212101447.gBAElpJ01949@localhost.localdomain>; from James.Bottomley@steeleye.com on Tue, Dec 10, 2002 at 08:47:50AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 10, 2002 at 08:47:50AM -0600, James Bottomley wrote:
> we should probably take the lowest of the scsi-1 minimum and the HBA if it 
> exists in scsi_initialize_queue and readjust it when we've decided on the 
> capabilities of the device.
> 
> In any event, moving the zero check for shpnt->max_sectors to 
> scsi_initialize_queue would fix the loss of scsi_add_host, wouldn't it?

Yepp.  Will you fix it or should I send a patch?

