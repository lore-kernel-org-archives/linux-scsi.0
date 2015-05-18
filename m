From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Mon, 18 May 2015 17:20:34 +0200
Message-ID: <20150518152034.GC5404@twins.programming.kicks-ass.net>
References: <20150518124058.GH21418@twins.programming.kicks-ass.net>
 <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbbERPUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 11:20:48 -0400
Content-Disposition: inline
In-Reply-To: <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Oelke, Mark" <mark.oelke@hp.com>
Cc: "don.brace@pmcs.com" <don.brace@pmcs.com>, ISS StorageDev <iss_storagedev@hp.com>, "storagedev@pmcs.com" <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, May 18, 2015 at 01:57:39PM +0000, Oelke, Mark wrote:
> The P212/P410/P411 firmware was recently spun to address an issue that sounds exactly like this problem.
> Which version of controller firmware are you using?

Smart Array P212 in Slot 1

   Hardware Revision: C
   Firmware Version: 6.60
