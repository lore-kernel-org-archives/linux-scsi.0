From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] new mac_scsi driver
Date: Thu, 24 Apr 2008 00:56:07 -0700 (PDT)
Message-ID: <20080424.005607.02325825.davem@davemloft.net>
References: <Pine.LNX.4.64.0804231833210.12067@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43300
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYDXH4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 03:56:10 -0400
In-Reply-To: <Pine.LNX.4.64.0804231833210.12067@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fthain@telegraphics.com.au
Cc: geert@linux-m68k.org, zippel@linux-m68k.org, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Thu, 24 Apr 2008 17:30:10 +1000 (EST)

> 
> Replace the mac_esp driver with a new one based on the esp_scsi core.
> 
> For esp_scsi: add support for sync transfers for the PIO mode, add a new 
> esp_driver_ops method to get the maximum dma transfer size (like the old 
> NCR53C9x driver), and some cleanups.
> 
> NB: the PDMA mode will not work without Roman's exception handling patch,
> http://marc.info/?l=linux-m68k&m=120344206029296&q=raw
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Acked-by: David S. Miller <davem@davemloft.net>

Nice work.
