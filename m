From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.22-rc3-mm1
Date: Thu, 31 May 2007 06:15:57 -0600
Message-ID: <20070531121557.GQ23968@parisc-linux.org>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38919 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328AbXEaMP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 08:15:59 -0400
Content-Disposition: inline
In-Reply-To: <20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Dan Williams <dan.j.williams@intel.com>

On Thu, May 31, 2007 at 02:09:22PM +0200, Cornelia Huck wrote:
> I split those functions out into a new file. Builds on s390 and i386.

Why not just put #ifdef CONFIG_HAS_DMA / #endif around the pair of
functions?  I don't see the need to add a new Kconfig symbol and a new
file for this.

