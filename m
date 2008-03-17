From: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Subject: Re: new kernel oops in recent kernels
Date: Mon, 17 Mar 2008 09:17:51 +0100
Message-ID: <1205741871.3515.9.camel@localhost>
References: <1205680748.3050.29.camel@localhost>
	 <20080316164223.GA26285@parisc-linux.org>
	 <1205692147.5470.3.camel@localhost>
	 <20080317044142.GC26285@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host194-211-dynamic.20-79-r.retail.telecomitalia.it ([79.20.211.194]:38908
	"EHLO eppesuigoccas.homedns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824AbYCQIRb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 04:17:31 -0400
Received: from router-wag54gp2 ([192.168.1.33] helo=[192.168.2.7])
	by eppesuigoccas.homedns.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <giuseppe@eppesuigoccas.homedns.org>)
	id 1JbAX9-0001hQ-1J
	for linux-scsi@vger.kernel.org; Mon, 17 Mar 2008 09:17:28 +0100
In-Reply-To: <20080317044142.GC26285@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,
I wrote a message to linux-mips mailing list for investigating on the
assembly code generated in sr_cdrom_status() since adding the suggested
printk() stopped the oops. I supposed there is a problem with the
compiler, but people there are investigating about problem with cache
coherency.
You may follow the thread on public web archive, at
http://www.linux-mips.org/archives/linux-mips/2008-03/msg00079.html

I'll be back on this list after checking any problem with cache
coherence and c compiler.

Thanks,
Giuseppe

