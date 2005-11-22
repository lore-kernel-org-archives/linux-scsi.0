From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 22 Nov 2005 15:20:33 -0700
Message-ID: <20051122222033.GQ1598@parisc-linux.org>
References: <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com> <1132056707.6134.11.camel@localhost.localdomain> <20051122083631.GA21523@infradead.org> <1132695837.8928.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:63645 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S964807AbVKVWUo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Nov 2005 17:20:44 -0500
Content-Disposition: inline
In-Reply-To: <1132695837.8928.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Ingo Juergensmann <ij@2005.bluespice.org>, Richard Hirst <rhirst@levanta.com>

On Tue, Nov 22, 2005 at 10:43:56PM +0100, Kars de Jong wrote:
> I don't really understand the current mechanism. It seems to result in
> different behaviour for BE systems depending on the definition of
> CONFIG_53C700_LE_ON_BE.

I think you misunderstand the meaning of that symbol.  It means "Support
little endian chips on a big endian processor".  Without it set, the
driver supports only little endian chips on little endian processors and
big endian chips on big endian processors.

> Was this driver ever used on BE systems without CONFIG_53C700_LE_ON_BE
> being defined?

I doubt it.
