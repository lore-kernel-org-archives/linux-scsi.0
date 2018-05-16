From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: simplify procfs code for seq_file instances V3
Date: Wed, 16 May 2018 14:28:01 +0100
Message-ID: <20180516132801.GO30522@ZenIV.linux.org.uk>
References: <20180516094346.20506-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180516094346.20506-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 16, 2018 at 11:43:04AM +0200, Christoph Hellwig wrote:
> We currently have hundreds of proc files that implement plain, read-only
> seq_file based interfaces.  This series consolidates them using new
> procfs helpers that take the seq_operations or simple show callback
> directly.
> 
> A git tree is available at:
> 
>     git://git.infradead.org/users/hch/misc.git proc_create.3

Pulled, but the last bit is a bleeding atrocity in need of followup
cleanup.
