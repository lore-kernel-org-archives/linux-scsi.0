From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] kill qlogicpti inquiry sniffing
Date: Sat, 19 Nov 2005 13:44:08 -0800 (PST)
Message-ID: <20051119.134408.127496042.davem@davemloft.net>
References: <20051017120229.GA5834@lst.de>
	<20051112091251.GA15402@lst.de>
	<20051119184447.GA29275@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20051119184447.GA29275@lst.de>
Sender: sparclinux-owner@vger.kernel.org
To: hch@lst.de
Cc: jejb@steeleye.com, tcallawa@redhat.com, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Sat, 19 Nov 2005 19:44:47 +0100

> ping^2.  Hey, there must be sparc users with this hardware that noticed
> the initial bug, could you please test this patch?

Tom's probably busy with other stuff, I'm sure he can get to
testing it eventually.

> Dave, could you look at the inquiry sniffing bug atleast?  I'm pretty
> the driver is doing the wrong thing about wide devices.  In general
> it might be worth to resync some code with the qla1280 driver which
> drivers the same chip with a pci bus interface (and more recent
> versions)

Yes it would be nice to write a SBUS front end to that driver.
Testing is always the issue though :-)
