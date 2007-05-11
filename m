From: David Miller <davem@davemloft.net>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 14:47:41 -0700 (PDT)
Message-ID: <20070511.144741.41878794.davem@davemloft.net>
References: <1178917967.3692.70.camel@mulgrave.il.steeleye.com>
	<20070511.142111.118971174.davem@davemloft.net>
	<1178919416.3692.82.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34566
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757793AbXEKVrg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 17:47:36 -0400
In-Reply-To: <1178919416.3692.82.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 11 May 2007 16:36:56 -0500

> On PARISC, we actually use a table of function pointers, but then we
> also have several other oddities including having to walk up the bus
> tree to find our IOMMU (having several) which can actually be on a
> different bus type for some of the older systems (i.e. the PCI iommu is
> in the GSC bus etc).

Yes and you can store such things in asm/device.h's dev_archdata,
that's another approach I considered.
