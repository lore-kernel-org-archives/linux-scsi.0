From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: Sat, 19 Jun 2004 01:10:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3brjg7994.fsf@defiant.pm.waw.pl>
References: <1087481331.2210.27.camel@mulgrave>
	<m33c4tsnex.fsf@defiant.pm.waw.pl>
	<20040618102120.A29213@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq.pm.waw.pl ([195.116.170.10]:15337 "EHLO hq.pm.waw.pl")
	by vger.kernel.org with ESMTP id S265755AbUFSNvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 09:51:18 -0400
In-Reply-To: <20040618102120.A29213@flint.arm.linux.org.uk> (Russell King's
 message of "Fri, 18 Jun 2004 10:21:20 +0100")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Russell King <rmk+lkml@arm.linux.org.uk> writes:

> Good idea, except for the fact that we have drivers merged which have
> real masks like 0x0fefffff.  It _really is_ a mask and not a number
> of bits.

Which drivers do you mean? And which platforms support it?
-- 
Krzysztof Halasa, B*FH
