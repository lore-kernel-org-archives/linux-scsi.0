From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/39] proc: introduce proc_create_seq{,_data}
Date: Tue, 24 Apr 2018 16:29:22 +0200
Message-ID: <20180424142922.GB26554@lst.de>
References: <20180419124140.9309-1-hch@lst.de> <20180419124140.9309-3-hch@lst.de> <20180419184106.GA2066@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419184106.GA2066@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Corey Minyard <minyard@acm.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 19, 2018 at 09:41:06PM +0300, Alexey Dobriyan wrote:
> Should be oopsable.
> Once proc_create_data() returns, entry is live, ->open can be called.

Ok, switching to opencoding proc_create_data instead.
