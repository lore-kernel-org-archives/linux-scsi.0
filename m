From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.17-rc1+git, Sym2: unknown symbol pcibios_resource_to_bus
 (fwd)
Date: Tue, 18 Apr 2006 21:02:20 -0700 (PDT)
Message-ID: <20060418.210220.54944830.davem@davemloft.net>
References: <20060417.131705.40072804.davem@davemloft.net>
	<20060417.132638.84565849.davem@davemloft.net>
	<20060419035908.GH24104@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:41095
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S1750760AbWDSEC2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 00:02:28 -0400
In-Reply-To: <20060419035908.GH24104@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, uclinux-v850@lsi.nec.co.jp, rmk@arm.linux.org.uk

From: Matthew Wilcox <matthew@wil.cx>
Date: Tue, 18 Apr 2006 21:59:08 -0600

> I suppose you don't test pci-pcmcia adapters very often on sparc64.
> 
> Is there a problem with adding the symbol export?  I noticed that v850
> also doesn't export that symbol.

I added it already.
