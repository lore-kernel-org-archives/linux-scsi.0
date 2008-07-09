From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 9 Jul 2008 16:49:29 +0100
Message-ID: <20080709164929.799e4e05@the-village.bc.nu>
References: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
	<20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	<4561.1215612914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42463 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753454AbYGIQWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 12:22:36 -0400
In-Reply-To: <4561.1215612914@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, dhowells@redhat.com, akpm@linux-foundation.org, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 09 Jul 2008 15:15:14 +0100
David Howells <dhowells@redhat.com> wrote:

> Miquel van Smoorenburg <miquels@cistron.nl> wrote:
> Maybe, but have you looked at i2o_cfg_passthru()?  Take this, for example:
> 
> 			/* Allocate memory for the transfer */
> 			p = kmalloc(sg_size, GFP_KERNEL);
> 			...
> 			//TODO 64bit fix
> 			sg[i].addr_bus = virt_to_bus(p);
> 
> That looks distinctly dodgy.  virt_to_bus() returns a 64-bit address, and as

Agreed - stick | GFP_DMA32 on the end then ;)


Alan
