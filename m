From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Wed, 29 Sep 2010 09:00:09 -0700
Message-ID: <987664A83D2D224EAE907B061CE93D5301605549DA@orsmsx505.amr.corp.intel.com>
References: <4ca2688f17705a0195@agluck-desktop.sc.intel.com>
 <20100928225936.GA8993@us.ibm.com>
 <987664A83D2D224EAE907B061CE93D5301605546A7@orsmsx505.amr.corp.intel.com>
 <20100929004213.GA9978@us.ibm.com>
 <987664A83D2D224EAE907B061CE93D530160554805@orsmsx505.amr.corp.intel.com>
 <20100929055539.GA17499@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0I2QAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 12:00:11 -0400
In-Reply-To: <20100929055539.GA17499@us.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Malahal Naineni <malahal@us.ibm.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>

> That makes sense! This patch should work and considers the above
> behaviour just as the old code. Please revert the commit and apply this
> patch instead. Please let me know if this works.

Yes, this new version works.

Tested-by: Tony Luck <tony.luck@intel.com>

Thanks

-Tony
