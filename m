From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: 24 Dec 2003 11:50:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072288242.1906.35.camel@mulgrave>
References: <1051920000.1054684267@aslan.btc.adaptec.com>
	<3637050000.1054690456@aslan.scsiguy.com>
	<2113050000.1072285128@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:35033 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263775AbTLXRur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Dec 2003 12:50:47 -0500
In-Reply-To: <2113050000.1072285128@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

On Wed, 2003-12-24 at 10:58, Justin T. Gibbs wrote:
> I've just uploaded version 2.0.5 of the aic79xx driver and version 
> 6.3.4 of the aic7xxx driver.  Both drivers are available for 2.4.X and
> 2.6.X kernels in either bk send format or as a tarball from here:

I thought when we adopted the latest aic driver for the 2.5 kernel, we
agreed to two things:

1. You'd send small regular updates as patches to linux-scsi
2. You wouldn't try to dump megabytes of patches into the stable kernel.

The diffstats on this patch are:

40 files changed, 6933 insertions(+), 5325 deletions(-)

And it's 640k in size.  You're also trying to rev the aic79xx driver
from 1.3.9 to 2.0.5; that's a bit of a major revision for a bugfix
release.

I'm really not happy dropping this into 2.6.1; what breadth of testing
outside of Adaptec has it had?

James


