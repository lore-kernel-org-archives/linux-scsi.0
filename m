From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Wed, 19 Dec 2007 23:58:07 -0800 (PST)
Message-ID: <20071219.235807.173273479.davem@davemloft.net>
References: <200712201645.19035.rusty@rustcorp.com.au>
	<20071220160741K.fujita.tomonori@lab.ntt.co.jp>
	<200712201853.48643.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49956
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbXLTH6O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 02:58:14 -0500
In-Reply-To: <200712201853.48643.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rusty@rustcorp.com.au
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 20 Dec 2007 18:53:48 +1100

> Manipulating the magic chains is horrible; it looks simple to the
> places which simply want to iterate through it, but it's awful for
> code which wants to create them.

I'm not saying complexity is inherent in this stuff, but
assuming that it is the complexity should live as far away
from the minions (the iterators in this case).  Therefore,
the creators is the right spot for the hard stuff.
