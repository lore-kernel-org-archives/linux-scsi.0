From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH] aic94xx: fix SMP request DMA direction
Date: Sat, 29 Sep 2007 08:22:15 +0200
Message-ID: <20070929062215.GD4239@rhun.haifa.ibm.com>
References: <20070928023341.GA10750@havoc.gtf.org> <20070928235534.GC22855@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:30575 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXI2GWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2007 02:22:18 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.13.8/8.13.8) with ESMTP id l8T6MHDD076124
	for <linux-scsi@vger.kernel.org>; Sat, 29 Sep 2007 06:22:17 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8T6MHKX2035732
	for <linux-scsi@vger.kernel.org>; Sat, 29 Sep 2007 08:22:17 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8T6MGUv005563
	for <linux-scsi@vger.kernel.org>; Sat, 29 Sep 2007 08:22:17 +0200
Content-Disposition: inline
In-Reply-To: <20070928235534.GC22855@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

On Fri, Sep 28, 2007 at 04:55:34PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 27, 2007 at 10:33:41PM -0400, Jeff Garzik wrote:
> > 
> > Unless I'm missing something, the SMP request goes /to/ the PCI device :)
> > 
> > Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> ACK; builds ok and SMP commands seem to work ok (not that they
> didn't before).

Could this explain some weirdness we were seeing with aic94xx and
Calgary/CalIOC2 enabled, or are SMP commands not likely to be used in
normal operation? We map the IOMMU entries differently for FROMDEVICE
(RW) and TODEVICE(RO).

Cheers,
Muli
-- 
SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
http://www.haifa.il.ibm.com/Workshops/systor2007/

Oct 29, 2007: virtualization workshop | Oct 30, 2007: storage workshop
