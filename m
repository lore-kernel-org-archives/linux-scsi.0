From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: 24 Dec 2003 13:05:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072292714.2415.39.camel@mulgrave>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	<3637050000.1054690456@aslan.s
	csiguy.com> <2113050000.1072285128@aslan.scsiguy.com>
	<1072288242.1906.35.camel@mulgrave>
	<2148850000.1072292121@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:22746 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263800AbTLXTFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Dec 2003 14:05:16 -0500
In-Reply-To: <2148850000.1072292121@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

On Wed, 2003-12-24 at 12:55, Justin T. Gibbs wrote:
> The last 10% is a change to having the driver completely do its own
> error recovery.  This change originated in late July and has received
> extensive testing since then.  This is the reason that a major driver
> version number bump was required for both drivers.  It is just not
> possible to get sane error recovery behavior if the mid-layer ever
> sees a timeout, so this really is a *bug fix*.

Elaborate on this more please...the error handling has been
substantially revised between 2.4 and 2.6 with a view to making it more
robust.  I don't recall seeing any bug reports from adaptec on the
issue, but if there's a mid-layer problem, I'm sure we can fix it.

James


