From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/39] ipmi: simplify procfs code
Date: Tue, 24 Apr 2018 16:16:01 +0200
Message-ID: <20180424141601.GC26136@lst.de>
References: <20180419124140.9309-1-hch@lst.de> <20180419124140.9309-17-hch@lst.de> <f322f243-9ab1-7e9f-00a4-9652cd288ca2@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f322f243-9ab1-7e9f-00a4-9652cd288ca2@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Corey Minyard <minyard@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 19, 2018 at 10:29:29AM -0500, Corey Minyard wrote:
> On 04/19/2018 07:41 AM, Christoph Hellwig wrote:
>> Use remove_proc_subtree to remove the whole subtree on cleanup instead
>> of a hand rolled list of proc entries, unwind the registration loop into
>> individual calls.  Switch to use proc_create_single to further simplify
>> the code.
>
> I'm yanking all the proc code out of the IPMI driver in 3.18.  So this is 
> probably
> not necessary.

Ok, I'll drop this patch.
