From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.17-rc1+git, Sym2: unknown symbol pcibios_resource_to_bus
Date: Mon, 17 Apr 2006 10:30:50 -0400
Message-ID: <1145284250.4574.1.camel@mulgrave.il.steeleye.com>
References: <Pine.SOC.4.61.0604171318410.5555@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16275 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751018AbWDQObI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 10:31:08 -0400
In-Reply-To: <Pine.SOC.4.61.0604171318410.5555@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-04-17 at 13:22 +0300, Meelis Roos wrote:
> WARNING: /lib/modules/2.6.17-rc1-gc19f7a9e/kernel/drivers/scsi/sym53c8xx_2/sym53c8xx.ko needs unknown symbol pcibios_resource_to_bus
> 
> Is is something missing from sparc64, or is sym53c8xx using something 
> arch-specific (pcibios sounds like it)?

pcibios_resource_to_bus is a new function which is inline in
asm-generic/pci.h.   However, sparc64 overrides it as an external
function which is in arch/sparc64/kernel/pci.c, so this looks like some
type of sparc issue.

James


