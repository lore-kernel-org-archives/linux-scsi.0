From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc3-mm1
Date: Thu, 31 May 2007 14:20:48 +0200
Message-ID: <20070531142048.05edf133@gondolin.boeblingen.de.ibm.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>
	<20070531121557.GQ23968@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:48236 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759522AbXEaMUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 08:20:49 -0400
In-Reply-To: <20070531121557.GQ23968@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Dan Williams <dan.j.williams@intel.com>

On Thu, 31 May 2007 06:15:57 -0600,
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, May 31, 2007 at 02:09:22PM +0200, Cornelia Huck wrote:
> > I split those functions out into a new file. Builds on s390 and i386.
> 
> Why not just put #ifdef CONFIG_HAS_DMA / #endif around the pair of
> functions?  I don't see the need to add a new Kconfig symbol and a new
> file for this.

I prefer a new file over #ifdefs in c files. (New dma-dependent stuff
would also have a place where it could go to.)

But I'll do whatever ends up as consensus :)
