From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: Wed, 23 Jun 2004 21:32:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m33c4myssf.fsf@defiant.pm.waw.pl>
References: <1087481331.2210.27.camel@mulgrave>
	<m33c4tsnex.fsf@defiant.pm.waw.pl>
	<20040618102120.A29213@flint.arm.linux.org.uk>
	<m3brjg7994.fsf@defiant.pm.waw.pl>
	<20040619212246.B8063@flint.arm.linux.org.uk>
	<m3zn6zf68l.fsf@defiant.pm.waw.pl>
	<20040620204723.B641@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq.pm.waw.pl ([195.116.170.10]:54224 "EHLO hq.pm.waw.pl")
	by vger.kernel.org with ESMTP id S266665AbUFWU57 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 16:57:59 -0400
In-Reply-To: <20040620204723.B641@flint.arm.linux.org.uk> (Russell King's
 message of "Sun, 20 Jun 2004 20:47:23 +0100")
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Russell King <rmk+lkml@arm.linux.org.uk> writes:

> So it's quite correct for this to be a device thing not a platform
> thing.  It _is_ the SA1111 device itself which has the problem.

Now I see that. Many thanks for detailed explanation.
-- 
Krzysztof Halasa, B*FH
