From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Export spi_populate_* functions
Date: Mon, 27 Feb 2006 07:49:06 -0700
Message-ID: <20060227144906.GC27759@parisc-linux.org>
References: <20060227141826.GB27759@parisc-linux.org> <1141050699.2992.113.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:26820 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751341AbWB0OtI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 09:49:08 -0500
Content-Disposition: inline
In-Reply-To: <1141050699.2992.113.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 27, 2006 at 03:31:38PM +0100, Arjan van de Ven wrote:
> On Mon, 2006-02-27 at 07:18 -0700, Matthew Wilcox wrote:
> > These functions should be usable by modules.
> 
> since this is new and very much linux specific code, shouldn't these be
> _GPL exports?

how is it very much linux specific?  these  functions take a char
pointer and fill in that buffer with the messages defined in the scsi
specs.  there's no linux data structures used.

http://git.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=blobdiff;h=c0051a432a97d1f9181229aff0fc9484df10c342;hp=97f4be62f748af9791d1a1932244ea604a1432e7;hb=49db0bbd2a3648b1da8dee31f803fc52a06c57e1;f=drivers/scsi/scsi_transport_spi.c
