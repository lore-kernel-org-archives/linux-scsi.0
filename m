From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: aic79xx: Unregister pci before failing module_init
Date: 01 May 2004 07:21:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1083414063.1756.1.camel@mulgrave>
References: <200404270501.i3R51h207741@mail.osdl.org>
	<20040501110425.GA29776@gondor.apana.org.au>
	<20040501112112.GA4677@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:34215 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261907AbUEAMVU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 May 2004 08:21:20 -0400
In-Reply-To: <20040501112112.GA4677@gondor.apana.org.au>
List-Id: linux-scsi@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@osdl.org>, gibbs@scsiguy.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-05-01 at 06:21, Herbert Xu wrote:
> I forgot to fix aic79xx's init code when no. devices found == 0.
> Here is the same fix that was applied to aic7xxx.

Actually, your patch doesn't boot on EISA enabled machines.  I'll
extract the fixup I did and apply to aic79xx.

James


