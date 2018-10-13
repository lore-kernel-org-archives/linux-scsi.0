From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] esp_scsi: De-duplicate PIO routines
Date: Sat, 13 Oct 2018 00:52:12 -0700
Message-ID: <20181013075212.GA23437@infradead.org>
References: <cover.1539391876.git.fthain@telegraphics.com.au>
 <09d3a141dc16af63921f5414263069e9b4f97222.1539391876.git.fthain@telegraphics.com.au>
 <20181013070508.GA15008@infradead.org>
 <alpine.LNX.2.21.1810131817540.375@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1810131817540.375@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 13, 2018 at 06:22:18PM +1100, Finn Thain wrote:
> > > +	pr_err("FIFO is empty (sreg %02x)\n", esp_read8(ESP_STATUS));
> > 
> > This should probably use dev_err (at least with my series).
> > 
> 
> How about shost_printk()? That would be consistent with the rest of 
> esp_scsi.c. It also means my series need not depend on yours which would 
> complicate things.

Yes, that sounds even better.
