From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: fix SMP request DMA direction
Date: Sat, 29 Sep 2007 02:25:33 -0400
Message-ID: <46FDEFDD.8070401@garzik.org>
References: <20070928023341.GA10750@havoc.gtf.org> <20070928235534.GC22855@tree.beaverton.ibm.com> <20070929062215.GD4239@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58553 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbXI2GZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2007 02:25:37 -0400
In-Reply-To: <20070929062215.GD4239@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi@vger.kernel.org

Muli Ben-Yehuda wrote:
> On Fri, Sep 28, 2007 at 04:55:34PM -0700, Darrick J. Wong wrote:
>> On Thu, Sep 27, 2007 at 10:33:41PM -0400, Jeff Garzik wrote:
>>> Unless I'm missing something, the SMP request goes /to/ the PCI device :)
>>>
>>> Signed-off-by: Jeff Garzik <jeff@garzik.org>
>> ACK; builds ok and SMP commands seem to work ok (not that they
>> didn't before).
> 
> Could this explain some weirdness we were seeing with aic94xx and
> Calgary/CalIOC2 enabled, or are SMP commands not likely to be used in
> normal operation? We map the IOMMU entries differently for FROMDEVICE
> (RW) and TODEVICE(RO).

SMP == scsi management == not used during normal data transfer.

It could certainly explain flakiness if you have expanders, though

	Jeff



