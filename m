From: Jurgen Kramer <gtm.kramer@inter.nl.net>
Subject: RE: 3ware 9000 driver kernel 2.6.7-rc3-mm1 vs 3ware 2.6 source
Date: Mon, 14 Jun 2004 22:26:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087244761.8713.1.camel@paragon.slim>
References: <HZBA4M03.GZU@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from slimnet.xs4all.nl ([194.109.194.192]:45533 "EHLO slimnas.slim")
	by vger.kernel.org with ESMTP id S263868AbUFNURd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 16:17:33 -0400
In-Reply-To: <HZBA4M03.GZU@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2004-06-14 at 20:30, Adam Radford wrote:
> Jurgen,
> 
> This is a small bug in the 3ware driver released on the install CD. 
> It is not correctly skipping channel or lun probing, therefore you
> get redundant devices.  You can rectify this situation by turning
> off 'Probe all LUNS for each scsi device' in your kernel config or
> update your driver.
> 
> Please contact 3ware for updated driver version.  
> 
> -Adam
> 
Adam,

Thanks for the reply. I need LUN support for my USB multicard reader so
I will contact 3ware for an updated driver.

Jurgen



