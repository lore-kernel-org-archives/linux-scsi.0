From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: status of the scsi changer driver
Date: Mon, 10 Jan 2005 12:52:43 +0100
Message-ID: <20050110115243.GA12837@harddisk-recovery.com>
References: <20050109120156.GA19296@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from users.linvision.com ([62.58.92.114]:26531 "HELO bitwizard.nl")
	by vger.kernel.org with SMTP id S262217AbVAJLwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 06:52:45 -0500
Content-Disposition: inline
In-Reply-To: <20050109120156.GA19296@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: kraxel@bytesex.org, linux-scsi@vger.kernel.org, debian-kernel@lists.debian.org

On Sun, Jan 09, 2005 at 01:01:56PM +0100, Christoph Hellwig wrote:
> do you plan to ever polish and submit the scsi changer driver for
> mainline inclusion?
> 
> We've been carring it along with the Debian kernel for a while, but
> it looks pretty much like a dead end currently.

FWIW, mtx (http://mtx.sourceforge.net/ ) worked rather nice last time I
tried with a Dell 8 slot DLT changer. It uses the sg interface rather
than a special scsi changer device.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
