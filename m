From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Wed, 17 Oct 2018 01:09:23 -0700
Message-ID: <20181017080923.GC24540@infradead.org>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
 <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
 <35ac9f31-7068-ab93-4629-363ee0bb4c70@suse.de>
 <alpine.LNX.2.21.1810151717520.10@nippy.intranet>
 <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
 <alpine.LNX.2.21.1810161611150.130@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1810161611150.130@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 16, 2018 at 04:39:07PM +1100, Finn Thain wrote:
> 
> Perhaps I've misunderstood your concern here. Is it a problem that 
> esp_scsi.ko may or may not export the function, depending on .config?
> 
> For example, if esp_scsi.ko came from a build with CONFIG_SUN3X_ESP=y && 
> !CONFIG_SCSI_ZORRO_ESP && !CONFIG_SCSI_MAC_ESP, then it would export no 
> esp_send_pio_cmd() symbol.
> 
> A dummy function (mentioned above) might then avoid a link error from 
> "modprobe zorro_esp" or "modprobe mac_esp" in this scenario. (The modules 
> would load but fail to work properly.)
> 
> This seems a bit too contrived so I'll post v3 for you to consider.

Please leave the possibly unused exports as-is.
