From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Mon, 15 Oct 2018 05:53:29 -0700
Message-ID: <20181015125329.GA8952@infradead.org>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
 <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
 <35ac9f31-7068-ab93-4629-363ee0bb4c70@suse.de>
 <alpine.LNX.2.21.1810151717520.10@nippy.intranet>
 <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2018 at 12:58:42PM +0200, Hannes Reinecke wrote:
> However, the function declaration really is a worry, as the actual function
> body only exists when the config option is enabled.

Having a prototype without an implementation is no problem at all.
We have this case all over the kernel, either intentionally to keep
things simple or due to bitrot.
