From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: 25 Oct 2002 11:04:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035540269.13032.7.camel@irongate.swansea.linux.org.uk>
References: <Pine.LNX.4.33L2.0210241350230.20950-100000@dragon.pdx.osdl.net>
	<Pine.LNX.4.33.0210241839490.10937-100000@rancor.yyz.somanetworks.com>
	<20021024232258.GA26093@kroah.com>  <3DB886B9.3060304@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DB886B9.3060304@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: Greg KH <greg@kroah.com>, Scott Murray <scottm@somanetworks.com>, "Randy.Dunlap" <rddunlap@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, 2002-10-25 at 00:48, Steven Dake wrote:
> Surprise extraction is not a simple problem especially to ensure the 
> device drivers exit
> cleanly without dumping more data on the PCI bus to a PCI device that 
> may not
> exist.

Thats primarily about resource handling orders. Making sure we don't
release the claimed pci resources in the driver until the driver itself
is sure it has shut up.

I'm doing suprise removal ok with the thinkpad 600 (in 2.4 with some
limits due to the 2.4 pci layer). Network stuff seems to be fine. The
block layer has major issues.

