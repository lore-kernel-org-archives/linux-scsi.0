From: Mark Lord <lsml@rtr.ca>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 16:34:37 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4165A85D.7080704@rtr.ca>
References: <4161A06D.8010601@rtr.ca> <416547B6.5080505@rtr.ca> <20041007150709.B12688@infradead.org> <4165624C.5060405@rtr.ca> <416565DB.4050006@pobox.com> <4165A45D.2090200@rtr.ca> <4165A766.1040104@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267945AbUJGUih@vger.kernel.org>
In-Reply-To: <4165A766.1040104@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lkml@rtr.ca>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:

> Overall, I don't see why it is so damned difficult to delete the hooks 
> then add them back when they _are_ needed.  I would certainly support 
> you in that effort.

Okay, that can work.

Except that the hooks ARE needed NOW.

Right NOW, there is a programmer working on the RAID management
interface, and he needs those hooks (or something similar)
to compile and test his code against the driver.

Remember, the vendor wants to decouple the RAID management from
the in-tree kernel code.  They fully want to open-source (GPL)
all of it, but in two pieces:  (1) core driver to boot/run the system,
and (2) loadable component to provide advanced RAID management.

It is anticipated that development of (2) will take some time
and have many revisions, and they really want to decouple it's
release from that of the stock kernel.  Thus, the latest version
of that code will be provided via website and installation CD
to customers who actually buy/use the product.

I wonder if there's a better way to do this?
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
