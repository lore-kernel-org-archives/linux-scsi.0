From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] Optionally disable QAS in MPT Fusion spi driver
Date: Thu, 15 Jun 2006 09:31:39 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70199848@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:11722 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030691AbWFOPbx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:31:53 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org

On Thursday, June 15, 2006 9:12 AM, Christoph Hellwig wrote: 
> 
> On Fri, Jun 02, 2006 at 03:14:25PM -0600, Andrew Patterson wrote:
> > Certain drives report that they support QAS, but it some 
> cases can have
> > trouble with it causing bus resets.  This patch optionally 
> disables QAS
> > for the MPT Fusion spi driver.  QAS is disabled using the 
> mpt_qas module
> > parameter.
> 
> I'm not very happy about making this a module paramater in 
> the LLDD as that
> can't scale.  This kind of stuff needs to be done in the 
> generic DV code.
> 

We had discussed this with James Bottomley at Storage Summit,
Sorry I wanted to run this by you as well, but forgot. 
The QAS enable/disable feature is per device in spi transport
layer, not per host, which is what we need.

James said it was okay for having this done in lld, instead
of transport.  I'm sure both me and Andrew would be happy 
the same if the transport handled this.  
Is that possible for you to look into this, or James?

Eric Moore
