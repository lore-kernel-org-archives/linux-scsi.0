From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 11/11] pm80xx : gpio feature support for motherboard
 controllers
Date: Sat, 16 Nov 2013 18:25:56 +0000
Message-ID: <1384626355.3614.10.camel@dabdike.int.hansenpartnership.com>
References: <1382444455-3168-1-git-send-email-Viswas.G@pmcs.com>
	 <526F8B95.8010900@gmail.com>
	 <DB8BCD22E410A84DA91083F3479A3DB31C67F7A2@BBYEXM01.pmc-sierra.internal>
	 <52777740.8070509@gmail.com>
	 <DB8BCD22E410A84DA91083F3479A3DB31C680618@BBYEXM01.pmc-sierra.internal>
	 <52809C23.507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:41273 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3KPS0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Nov 2013 13:26:07 -0500
In-Reply-To: <52809C23.507@gmail.com>
Content-Language: en-US
Content-ID: <A226D0460D27994B906229241CE76B7E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

On Mon, 2013-11-11 at 09:58 +0100, Jack Wang wrote:
> Hi James,
> 
> About this gpio feature, do you think it's OK to implement with IOCTL

Definitely not via another strange ioctl

> or we can use exist bsg interface in libsas and add another function call?

My default thought is that it should go via bsg and libsas if you can
find a SES expander type emulation, which would be nice, but perhaps
complex.  Otherwise it should probably go via the gpio subsystem,
possibly via a SFF-8485 driver (which I don't think exists).

James

