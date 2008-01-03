From: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: advansys broken (at least) on ARM and MIPS
Date: Thu, 3 Jan 2008 09:50:35 -0500
Message-ID: <20080103145035.GA4749@fattire.cabal.ca>
References: <20080103074353.GD22470@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from there.is.no.cabal.ca ([134.117.69.58]:60559 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYACOuh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 09:50:37 -0500
Content-Disposition: inline
In-Reply-To: <20080103074353.GD22470@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>

On Thu, Jan 03, 2008 at 08:43:53AM +0100, Martin Michlmayr wrote:
> MIPS:
> 
>   Building modules, stage 2.
>   MODPOST 64 modules
> ERROR: "free_dma" [drivers/scsi/advansys.ko] undefined!
> 

needs to depend on GENERIC_ISA_DMA_API
