From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Thu, 24 May 2007 01:51:19 -0400
Message-ID: <465527D7.6030909@garzik.org>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>	 <4654BB27.6050706@garzik.org> <1179960902.5569.48.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40882 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213AbXEXFv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 May 2007 01:51:26 -0400
In-Reply-To: <1179960902.5569.48.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

James Bottomley wrote:
> It's not a bug fix or even an enhancement.  Historically, it is quite
> difficult to get maintainers to ack these ... particularly if you don't
> cc them.

If neither you nor the maintainers are reading and responding to patches 
sent to linux-scsi, I don't think the problem is sitting in my chair.

If others have SCSI patches that have been sitting in limbo for weeks or 
months, send them to me, and I'll queue them in misc-2.6.git#scsi.

	Jeff



