From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 10:44:37 -0500
Message-ID: <1151336678.2673.9.camel@mulgrave.il.steeleye.com>
References: <447AB2F5.2000700@s5r6.in-berlin.de>
	 <20060529130515.GE23405@parisc-linux.org>
	 <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	 <20060601132315.GD32143@parisc-linux.org>
	 <1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	 <20060625224631.GD1608@parisc-linux.org>
	 <1151310285.3185.16.camel@laptopd505.fenrus.org>
	 <20060626124001.GG1608@parisc-linux.org>
	 <20060626144442.GA13319@one-eyed-alien.net>
	 <20060626151828.GH1608@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2250 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750706AbWFZPot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 11:44:49 -0400
In-Reply-To: <20060626151828.GH1608@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-hotplug-devel@lists.sourceforge.net, Patrick Mansfield <patmans@us.ibm.com>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>

On Mon, 2006-06-26 at 09:18 -0600, Matthew Wilcox wrote:
> It's definitely possible to remove individual targets dynamically now;
> Fibre Channel has sorted that out (and will complain loudly if it
> breaks).
> The scsi core doesn't really have a channel object; channel is just an
> integer 
> that describes a path to a target.  So I think there should be no
> problem in
> converting USB to have one host and many channels.

Actually, I think usb should be exactly like FC ... in that should be an
unscanned attachment, so if and when it gets done properly, it won't
have any need for the async scanning updates anyway.

James


