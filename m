From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: Fri, 18 Jun 2004 10:21:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040618102120.A29213@flint.arm.linux.org.uk>
References: <1087481331.2210.27.camel@mulgrave> <m33c4tsnex.fsf@defiant.pm.waw.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:6663 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S265085AbUFRJV0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 05:21:26 -0400
Content-Disposition: inline
In-Reply-To: <m33c4tsnex.fsf@defiant.pm.waw.pl>; from khc@pm.waw.pl on Fri, Jun 18, 2004 at 02:46:46AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Jun 18, 2004 at 02:46:46AM +0200, Krzysztof Halasa wrote:
> If we fix the API we should IMHO also remove set_dma_mask() and add
> the number of address bits to the arguments of actual mapping
> functions.

Good idea, except for the fact that we have drivers merged which have
real masks like 0x0fefffff.  It _really is_ a mask and not a number
of bits.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 PCMCIA      - http://pcmcia.arm.linux.org.uk/
                 2.6 Serial core
