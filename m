From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Patch(2.5.56): ide-scsi.c hotplug-oriented rearrangement
Date: Mon, 13 Jan 2003 18:13:26 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113181326.A28334@infradead.org>
References: <20030113025111.A3630@baldur.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030113025111.A3630@baldur.yggdrasil.com>; from adam@yggdrasil.com on Mon, Jan 13, 2003 at 02:51:11AM -0800
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: linux-scsi@vger.kernel.org, gadio@netvision.net.il, andre@linux-ide.org, axboe@suse.de, alan@lxorguk.ukuu.org.uk

On Mon, Jan 13, 2003 at 02:51:11AM -0800, Adam J. Richter wrote:
> 	If nobody sees a problem with this patch, then I'd like to
> move forward on getting it into Linus's releases.  Any help would be
> appreciated.

The patch looks good to me.  I wonder a bit whether ide-scsi devices
shouldn't better hang of the ide tree in sysfs somehow, but that's something
that can be addressed later.

