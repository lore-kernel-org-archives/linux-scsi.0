From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [RFC][PATCH] move dma_mask into struct device
Date: Sun, 17 Nov 2002 09:07:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211171507.gAHF7de11633@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA21686
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 07:07:48 -0800
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Sat, 16 Nov 2002 12:33:51 PST." <20021116123351.A7537@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "J.E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, grundler@dsl2.external.hp.com, willy@debian.org

patmans@us.ibm.com said:
> Can shost->host_driverfs_dev.parent be used instead of adding and
> using a duplicate shost->dev? 

I think so. I believe the parent is always the device we're looking for.  I'll 
make the fix.

James


