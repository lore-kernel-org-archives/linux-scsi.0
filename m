From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 01:42:11 -0700 (PDT)
Message-ID: <20071017.014211.41637735.davem@davemloft.net>
References: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
	<20071017072149.GC5041@kernel.dk>
	<20071017.013325.74747630.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41821
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755338AbXJQImB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 04:42:01 -0400
In-Reply-To: <20071017.013325.74747630.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 17 Oct 2007 01:33:25 -0700 (PDT)

> sg_next() gives you a NULL after the last entry, but tests have been
> changed to compare against sg_last() which is likely not what we
> want for those checks.

This of course isn't true, ignore me as I'm still learning how this
new stuff works :-)
