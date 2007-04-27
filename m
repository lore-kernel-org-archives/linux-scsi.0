From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] esp_scsi.c: fix compilation
Date: Fri, 27 Apr 2007 15:10:00 -0700 (PDT)
Message-ID: <20070427.151000.92584323.davem@davemloft.net>
References: <20070427220901.GC5986@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43626
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757486AbXD0WJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2007 18:09:51 -0400
In-Reply-To: <20070427220901.GC5986@martell.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adobriyan@gmail.com
Cc: torvalds@osd.org, akpm@osdl.org, linux-scsi@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 28 Apr 2007 02:09:01 +0400

> irqreturn.h for irqreturn_t and dma_addr_t being u128 warnings ;-)
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

I'll apply this, thanks.
