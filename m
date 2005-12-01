From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Removing BROKEN scsi drivers
Date: Thu, 01 Dec 2005 14:47:01 -0600
Message-ID: <1133470022.5232.20.camel@mulgrave>
References: <20051005123220.GB6490@levanta.com>
	 <1128519034.5063.10.camel@laptop-lcs.localdomain>
	 <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
	 <20051007134232.GA6490@levanta.com>
	 <1128693232.5041.7.camel@laptop-lcs.localdomain>
	 <20051115095152.GA23470@infradead.org>
	 <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
	 <1132056707.6134.11.camel@localhost.localdomain>
	 <20051122083631.GA21523@infradead.org>
	 <1132695837.8928.11.camel@localhost.localdomain>
	 <1133110038.3331.20.camel@mulgrave>  <1133303092.3492.58.camel@mulgrave>
	 <1133469794.5759.8.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33206 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751725AbVLAUrR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 15:47:17 -0500
In-Reply-To: <1133469794.5759.8.camel@kars.perseus.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Ingo Juergensmann <ij@2005.bluespice.org>, Richard Hirst <rhirst@levanta.com>

On Thu, 2005-12-01 at 21:43 +0100, Kars de Jong wrote:
> I noticed one thing in the patch:
> 
> > +#ifdef CONFIG_53C700_BE_BUS)
>                               ^
> There's a trailing ) there.

Well .. since you'll be the first user of the config option, could you
fix it when you add your driver ...

Thanks,

James


