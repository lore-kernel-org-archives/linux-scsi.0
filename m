From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.17-rc1+git, Sym2: unknown symbol pcibios_resource_to_bus
 (fwd)
Date: Mon, 17 Apr 2006 13:17:05 -0700 (PDT)
Message-ID: <20060417.131705.40072804.davem@davemloft.net>
References: <Pine.SOC.4.61.0604171849100.21709@math.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:62383
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S1750850AbWDQURK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 16:17:10 -0400
In-Reply-To: <Pine.SOC.4.61.0604171849100.21709@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Mon, 17 Apr 2006 18:49:41 +0300 (EEST)

Putting linux-scsi and James back on the CC:

> Forwarded from linux-scsi.
 ...
> pcibios_resource_to_bus is a new function which is inline in
> asm-generic/pci.h.   However, sparc64 overrides it as an external
> function which is in arch/sparc64/kernel/pci.c, so this looks like some
> type of sparc issue.

Why does the SYM2 driver possible even need this symbol?
That's what I'd like to have explained.

When this slipped into the Ubuntu kernel, I pushed back on it because
the usage was bogus, and I fear this is the same exact thing rearing
it's ugly head.

There is no reason to export this symbol outside of the generic PCI
code, which does not require a module symbol export.
