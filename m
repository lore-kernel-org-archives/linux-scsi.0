From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] Perverting cciss
Date: Thu, 5 Apr 2007 14:37:18 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8CD40B74@G3W0639.americas.hpqcorp.net>
References: <4614C82E.1020100@suse.de> <20070405100326.GA19092@infradead.org> <1175782151.3714.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:48353 "EHLO
	ccerelbas04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767024AbXDEOwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Apr 2007 10:52:02 -0400
Content-class: urn:content-classes:message
In-reply-to: <1175782151.3714.13.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James wrote: 
> 
> On Thu, 2007-04-05 at 11:03 +0100, Christoph Hellwig wrote:
> > On Thu, Apr 05, 2007 at 11:58:06AM +0200, Hannes Reinecke wrote:
> > > Hi All,
> > > 
> > > this patch adds the SG_IO ioctl to the cciss driver.
> > > As the driver is capable of sending SCSI CDBs to the controller 
> > > there is no reason why we shouldn't exploit it.
> > > This way we get to use all the nice sg_utils for the cciss driver.
> > > And a persistent device name for free.
> > 
> > Instead of adding yet another implementation of SG_IO 
> please implement 
> > support for REQ_TYPE_BLOCK_PC requests and add all the nice block 
> > layer passthrough ioctls to it.
> 
> Actually, I happen to know that HP is in the process of 
> implementing this correctly (via REQ_TYPE_BLOCK_PC).  I can't 
> reveal the details but it has something to do with a well 
> known Linux High Availability company needing SG_IO for 
> sg_persist to work ...
> 
> James

NAK. Please do not add this patch to cciss. We are working SG_IO
internally and will post the patch soon.

mikem


> 
> 
> 
