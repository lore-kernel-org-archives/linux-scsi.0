From: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Subject: Re: new kernel oops in recent kernels
Date: Sun, 16 Mar 2008 19:32:40 +0100
Message-ID: <1205692360.5470.6.camel@localhost>
References: <1205680748.3050.29.camel@localhost>
	 <1205685580.6767.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host194-211-dynamic.20-79-r.retail.telecomitalia.it ([79.20.211.194]:57600
	"EHLO eppesuigoccas.homedns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbYCPSeU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Mar 2008 14:34:20 -0400
Received: from router-wag54gp2 ([192.168.1.33] helo=[192.168.2.7])
	by eppesuigoccas.homedns.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <giuseppe@eppesuigoccas.homedns.org>)
	id 1JaxgW-0000gg-Mk
	for linux-scsi@vger.kernel.org; Sun, 16 Mar 2008 19:34:18 +0100
In-Reply-To: <1205685580.6767.87.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi James,

Il giorno dom, 16/03/2008 alle 11.39 -0500, James Bottomley ha scritto:
> On Sun, 2008-03-16 at 16:19 +0100, Giuseppe Sacco wrote:
[...]
> This is a bit strange.  It's obviously O2 specific, which makes it a lot
> harder.  Can you compile the kernel with CONFIG_DEBUG_INFO and reproduce
> (just in case this changes the symbol layout).  Then ask gdb where
[...]

I cannot find any CONFIG_DEBUG_INFO. Do you mean CONFIG_DEBUG_KERNEL?

Thanks,
Giuseppe

