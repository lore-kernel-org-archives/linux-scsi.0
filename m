From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 16:52:54 -0500
Message-ID: <1178920374.3692.90.camel@mulgrave.il.steeleye.com>
References: <1178917967.3692.70.camel@mulgrave.il.steeleye.com>
	 <20070511.142111.118971174.davem@davemloft.net>
	 <1178919416.3692.82.camel@mulgrave.il.steeleye.com>
	 <20070511.144741.41878794.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52383 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349AbXEKVw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 17:52:58 -0400
In-Reply-To: <20070511.144741.41878794.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-05-11 at 14:47 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Fri, 11 May 2007 16:36:56 -0500
> 
> > On PARISC, we actually use a table of function pointers, but then we
> > also have several other oddities including having to walk up the bus
> > tree to find our IOMMU (having several) which can actually be on a
> > different bus type for some of the older systems (i.e. the PCI iommu is
> > in the GSC bus etc).
> 
> Yes and you can store such things in asm/device.h's dev_archdata,
> that's another approach I considered.

yes ... that's sort of why it exists ... arm wanted more than just the
void *platform_data which is where we stuff the iommu information on
parisc.  Really, I suppose it's time we eliminated platform_data and
just used dev_archdata instead.

James


