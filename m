From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] lpfc 10.2.8001.0: Removed obsolete PCI IDs from the
 driver
Date: Mon, 19 May 2014 10:53:29 -0700
Message-ID: <20140519175329.GA16778@infradead.org>
References: <1399910007.25346.10.camel@myfc17>
 <20140519171944.GC32250@infradead.org>
 <537A41E6.8010607@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaESRx3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 13:53:29 -0400
Content-Disposition: inline
In-Reply-To: <537A41E6.8010607@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, May 19, 2014 at 01:39:50PM -0400, James Smart wrote:
> :)
> 
> for those distros, that want to pull only upstream'd patches, and
> where customers expect someone to take phone calls on any hardware
> recognized by the distro... the patch is to remove the hardware
> Emulex/the distro won't answer any questions for anymore.
> 
> true - the hardware, if you can find it lying around somewhere, may
> still function. It won't get firmware updates, nor any mindshare.
> I'm not sure where the policy is for upstream - is it truly once
> known, can never be taken away ?

The policy is to leave it in even if unsupported, and let it it slowly
bitrot.  In some cases users will step up and maintain it, in most cases
we will be able to recycle it after a few years.

How about you stick in a printk that Emulex doesn't support the driver
for these cards anymore?

