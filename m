From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: [PATCH] ips driver for 2.4.23-pre4
Date: Thu, 08 Jan 2004 19:18:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFD9F0E.4060604@wanadoo.es>
References: <3FFC5B2C.6000302@wanadoo.es> <20040108171531.B12595@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp11.eresmas.com ([62.81.235.111]:24789 "EHLO
	smtp11.eresmas.com") by vger.kernel.org with ESMTP id S265592AbUAHSUG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 13:20:06 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

Christoph Hellwig wrote:

> On Wed, Jan 07, 2004 at 08:17:00PM +0100, Xose Vazquez Perez wrote:
> 
>>-#if !defined(__i386__) && !defined(__ia64__)
>>-#error "This driver has only been tested on the x86/ia64 platforms"
>>+#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
>>+#error "This driver has only been tested on the x86/ia64/x86_64 platforms"
>> #endif
> 
> 
> This warning schould be removed completly.  Lots of PCI drivers have
> been tested only on a few plattforms.
> 
> Else the patch is okay, but where's the maintainer?

the maintainer sent this patch _directly_ to Marcelo, again.

Ask to them:
Jack Hammer <Jack_Hammer@adaptec.com> David Jeffery <David_Jeffery@adaptec.com>

