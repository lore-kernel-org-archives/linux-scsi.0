From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 23/28] scsi cd: VariRec, GigaRec and PowerRec as user
Date: Wed, 08 Mar 2006 09:12:06 -0600
Message-ID: <1141830726.3194.8.camel@mulgrave.il.steeleye.com>
References: <200603080816.k288GSQO002236@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:19360 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750712AbWCHPMP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 10:12:15 -0500
In-Reply-To: <200603080816.k288GSQO002236@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, T.Maguin@web.de, axboe@suse.de

On Wed, 2006-03-08 at 00:14 -0800, akpm@osdl.org wrote:
> From: Thomas Maguin <T.Maguin@web.de>

> This patch allows normal users to eectute some Plextor drives
> commands:
> 
> - Hide CD-R
> - SingleSession
> - SpeedRead
> - PowerRec
> - VariRec
> - GigaRec
> 

This one just isn't safe.  We can't add vendor specific commands to the
permissions table because they mean different things to different
vendors ... get mode on one could be halt and catch fire on another, so
the whole concept of safety via command verification is lost.

I don't happen to believe in this type of command verification anyway,
so I'd be perfectly happy to switch this over to a better facility (like
capabilities), but while you're claiming to vet commands, you have to be
logically correct (which means no vendor specific commands).

James




