From: hch@infradead.org
Subject: Re: ahc1542 fun
Date: Wed, 26 May 2004 02:44:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040526064430.GA21531@infradead.org>
References: <40B401AE.9060707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.217.7]:40455 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S265325AbUEZGoh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 02:44:37 -0400
Content-Disposition: inline
In-Reply-To: <40B401AE.9060707@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Tue, May 25, 2004 at 10:32:14PM -0400, Jeff Garzik wrote:
> 
> The old 1542 scsi driver is both ISA and MCA.  The MCA portions are 
> disabled when !CONFIG_MCA through the typical wrapper scheme (a la pci.h 
> and !CONFIG_PCI).  However...  the driver unconditionally includes 
> linux/mca.h which in turn unconditionally includes asm/mca.h.
> 
> This breaks drivers on platforms with ISA but not MCA, like alpha.
> 
> (and I suppose any PCI platform, since you could have one on an ISA bridge)

This needs fixing in mca.h and mca-legacy.h.  The debian kernel package
has a fix that I don't quite like.  I'll rework it in the next days and
submit it.

