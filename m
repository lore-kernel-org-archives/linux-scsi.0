From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Tue, 28 Sep 2010 16:40:25 -0700
Message-ID: <987664A83D2D224EAE907B061CE93D5301605546A7@orsmsx505.amr.corp.intel.com>
References: <4ca2688f17705a0195@agluck-desktop.sc.intel.com>
 <20100928225936.GA8993@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab0I1Xk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2010 19:40:28 -0400
In-Reply-To: <20100928225936.GA8993@us.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Malahal Naineni <malahal@us.ibm.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>

> Let me know if this fixes the problem. Thank you very much.

No it doesn't :-(

I still end up with 0xffffffff from the *host_dev->dma_mask
later in that function.

Just for two devices though ... stack traces lead back to
usb_stor_scan_thread() for these two.

-Tony
