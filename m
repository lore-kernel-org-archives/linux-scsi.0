From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] SGIWD93: use cached memory access to make driver work
	on IP28
Date: Wed, 28 Nov 2007 09:50:09 +0000
Message-ID: <20071128095009.GA11063@linux-mips.org>
References: <20071126223921.A566CC2B26@solo.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:59146 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbXK1O1i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2007 09:27:38 -0500
Received: from localhost.localdomain ([127.0.0.1]:53228 "EHLO
	dl5rb.ham-radio-op.net") by ftp.linux-mips.org with ESMTP
	id S20030845AbXK1O1h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Nov 2007 14:27:37 +0000
Content-Disposition: inline
In-Reply-To: <20071126223921.A566CC2B26@solo.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, James.Bottomley@HansenPartnership.com

On Mon, Nov 26, 2007 at 06:41:15PM +0100, Thomas Bogendoerfer wrote:

> Following patch is 2.6.25 material needed to get SGI IP28 machines
> supported.
> 
> Thomas.
> 
> SGI IP28 machines would need special treatment (enable adding addtional
> wait states) when accessing memory uncached. To avoid this pain I
> changed the driver to use only cached access to memory.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Same comment as for SGISEEQ: IP28 is clearly a maximum weirdo beast.
Technically the patch looks fine it's just a few stilistic issues such as
there no reason for DMA_SYNC_DESC_CPU and DMA_SYNC_DESC_DEV being macros
so why not using inlines.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
