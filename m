From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: gdth new set of patches for 2.6.24 stable
Date: Tue, 19 Feb 2008 14:37:46 +0000
Message-ID: <20080219143746.GA15236@linux-mips.org>
References: <47B48CAE.2020705@panasas.com> <47B864CB.4040604@panasas.com> <20080218045736.d35d5408.akpm@linux-foundation.org> <200802181227.43166.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:36334 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYBSOiB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2008 09:38:01 -0500
Received: from localhost.localdomain ([127.0.0.1]:50923 "EHLO
	dl5rb.ham-radio-op.net") by ftp.linux-mips.org with ESMTP
	id S20024525AbYBSOiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 14:38:00 +0000
Content-Disposition: inline
In-Reply-To: <200802181227.43166.david-b@pacbell.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Boaz Harrosh <bharrosh@panasas.com>, Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>, Russell King <rmk@arm.linux.org.uk>

On Mon, Feb 18, 2008 at 12:27:42PM -0800, David Brownell wrote:

> > Actually I think David might have been wrong about mips. =A0afaict =
its
> > dma_free_coherent() is callable under local_irq_disable(), so ARM S=
MP is
> > the sole exception? =A0
>=20
> All I recall at this point was getting some arch-specific patches in =
that
> area; I thought it was MIPS, maybe it was PPC.  The arch code may hav=
e
> changed since then too.

Mostly to avoid code duplication on the MIPS side but the core of the
implementation has always been similar to what it is currently.

  Ralf
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
