From: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 14:37:54 -0700 (PDT)
Message-ID: <20070615.143754.28790010.davem@davemloft.net>
References: <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
	<20070615.141720.112626963.davem@davemloft.net>
	<4673047F.30808@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53344
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbXFOVhu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 17:37:50 -0400
In-Reply-To: <4673047F.30808@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 15 Jun 2007 17:28:31 -0400

> David Miller wrote:
> > If the SCSI guys were smart, there would be a totally generic helper
> > layer that allows anyone to hook into the SCSI layer as a virtual SCSI
> > disk provider in like 10 lines of code. :-)
> 
> The SCSI target code gives you the capability to do that (the SCSI 
> transport part, the virtual storage part is easy from there).

I don't get to control the server side in my case, I'm a client
talking to something with a pre-determined interface.
