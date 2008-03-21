From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] WD33C93: let platform stub override
	no_sync/fast/dma_mode
Date: Fri, 21 Mar 2008 22:12:30 +0000
Message-ID: <20080321221230.GA5097@linux-mips.org>
References: <20080321212543.6F769C2DF8@solo.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:48730 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYCUWMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Mar 2008 18:12:42 -0400
Received: from localhost.localdomain ([127.0.0.1]:49884 "EHLO
	dl5rb.ham-radio-op.net") by ftp.linux-mips.org with ESMTP
	id S28578770AbYCUWMk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 22:12:40 +0000
Content-Disposition: inline
In-Reply-To: <20080321212543.6F769C2DF8@solo.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, James.Bottomley@HansenPartnership.com

On Fri, Mar 21, 2008 at 10:25:43PM +0100, Thomas Bogendoerfer wrote:

> SGI machines with WD33C93 allow usage of burst mode DMA, which increases
> performance noticable. To make this selectable by the sgiwd93 stub,
> setting the values for no_sync, fast and dma_mode has been moved to the
> individual platform stubs.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

This is one of the things on my list of things to be fixed for IP22 for
even longer than I can recall.  Thanks Thomas!

  Ralf
