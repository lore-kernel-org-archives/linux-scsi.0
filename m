From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [RFC][PATCH] move dma_mask into struct device
Date: Sat, 16 Nov 2002 09:48:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211161448.gAGEmYl02479@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA02652
	for <linux-scsi@vger.kernel.org>; Sat, 16 Nov 2002 06:48:43 -0800
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Fri, 15 Nov 2002 16:19:14 PST." <20021116001914.GA3153@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, grundler@dsl2.external.hp.com, willy@debian.org

andmike@us.ibm.com said:
> I got a compile error here. This should be.
> 	dev->dev.dma_mask = &dev->dma_mask; 

Oops, yes, that's what comes of making changes in code you don't compile.

> The machine is a 2x pci systems with the following drivers loaded:
> 	aic7xxx, ips, qlogicisp. 

Thanks for testing it.

James


