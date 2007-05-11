From: David Miller <davem@davemloft.net>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 14:21:11 -0700 (PDT)
Message-ID: <20070511.142111.118971174.davem@davemloft.net>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
	<20070511.130024.104034874.davem@davemloft.net>
	<1178917967.3692.70.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53976
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761397AbXEKVVI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 17:21:08 -0400
In-Reply-To: <1178917967.3692.70.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 11 May 2007 16:12:47 -0500

> I could probably cook up a patch for you, if you like? ... I've already
> done it for several other architectures.

I don't want to use that "if (bus == &sbus_bus_type)" scheme so
if that's what your patch will do don't bother :-)

I'm consolidating all of the IOMMU handling code on sparc64
since they all do exactly the same thing, so at least on
sparc64 there will be essentially direct calls to the IOMMU
code agnostic of bus type.

Sparc32 will be a bit different, and that platform has no
active maintainer so it'll have to wait until I have a
spare weekend to do nothing but sparc32 stuff :-)

