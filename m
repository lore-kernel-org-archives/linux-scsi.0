From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Date: Thu, 13 Dec 2007 11:53:26 -0700
Message-ID: <20071213185326.GQ26334@parisc-linux.org>
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca> <47617E72.6080504@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47617E72.6080504@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 13, 2007 at 01:48:18PM -0500, Mark Lord wrote:
> Problem confirmed.  2.6.23.8 regularly generates segments up to 64KB for 
> libata,
> but 2.6.24 uses only 4KB segments and a *few* 8KB segments.

Just a suspicion ... could this be slab vs slub?  ie check your configs
are the same / similar between the two kernels.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
