From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: Sat, 27 Dec 2003 01:08:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031227060858.GA19523@gtf.org>
References: <3637050000.1054690456@aslan.scsiguy.com> <2113050000.1072285128@aslan.scsiguy.com> <1072288242.1906.35.camel@mulgrave> <2148850000.1072292121@aslan.scsiguy.com> <1072292714.2415.39.camel@mulgrave> <2304040000.1072326693@aslan.scsiguy.com> <1072463795.1873.127.camel@mulgrave> <2832150000.1072484024@aslan.scsiguy.com> <1072495231.1873.363.camel@mulgrave> <2906490000.1072499170@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([63.247.75.124]:132 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S265331AbTL0GI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2003 01:08:59 -0500
Content-Disposition: inline
In-Reply-To: <2906490000.1072499170@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

On Fri, Dec 26, 2003 at 09:26:10PM -0700, Justin T. Gibbs wrote:
> > On Fri, 2003-12-26 at 18:13, Justin T. Gibbs wrote:
> > I'm prepared to allow driver writers a considerable amount of slack in
> > terms of deviation from the coding standards, useless and obfuscating
> > compatibility layers and #ifdef'd code that can never be compiled in
> > 2.6; however, this attempt to hijack the basic SCSI APIs within the
> > adaptec driver is unacceptable.  Please take it out and resubmit the
> > patch without it.
> 
> I'm sorry you feel that way.  I suppose I will just have to continue
> to point distributors and users of this driver to my own patch sets since
> that seems to be the only viable alternative you've given me.

Red Hat has a very strong "do it in upstream first" policy these days.

There are reasons for this, and this situation is _precisely_ why.

	Jeff



