From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 06/40] proc: introduce proc_create_single{,_data}
Date: Thu, 26 Apr 2018 11:45:50 +1000 (AEST)
Message-ID: <alpine.LNX.2.21.1804261118050.8@nippy.intranet>
References: <20180425154827.32251-1-hch@lst.de> <20180425154827.32251-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425154827.32251-7-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 25 Apr 2018, Christoph Hellwig wrote:

>  
> -/*
> - * /proc/nubus stuff
> - */
> -

I don't think that the introduction of proc_create_single{,_data} alters 
the value of that comment. That comment and similar comments in the same 
file do have a purpose, which is to keep separate the /proc/nubus 
implementation is kept separate from the /proc/bus/nubus/devices 
implementation and so on.

-- 
