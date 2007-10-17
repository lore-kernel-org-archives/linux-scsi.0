From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 04:18:23 -0700 (PDT)
Message-ID: <20071017.041823.48807727.davem@davemloft.net>
References: <20071017110142.GU5043@kernel.dk>
	<20071017.041004.21594558.davem@davemloft.net>
	<20071017111146.GW5043@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41689
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758011AbXJQLSK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 07:18:10 -0400
In-Reply-To: <20071017111146.GW5043@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 17 Oct 2007 13:11:46 +0200

> On Wed, Oct 17 2007, David Miller wrote:
> > Jens, please also add the following on top of Fujita-san's most recent
> > sparc64 patch and we should be good to go.
> 
> Awesome, thanks. And sorry for messing up sparc64.

Don't worry, I'll keep breaking your network interfaces
just to keep things even :-)
