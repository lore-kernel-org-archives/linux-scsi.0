From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [rant] can we get asane ic7xxx/79xx probing _please_
Date: 13 Sep 2004 22:56:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095130611.3144.358.camel@mulgrave>
References: <20040906182402.GA25103@lst.de> <413F01C3.9020202@adaptec.com>
	<20040908130340.GA27693@lst.de> <413F0CC3.4020408@adaptec.com>
	<1094653835.7222.43.camel@mulgrave>  <20040912140822.GA2524@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22505 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269147AbUINC5B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 22:57:01 -0400
In-Reply-To: <20040912140822.GA2524@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-09-12 at 10:08, Christoph Hellwig wrote:
> On Wed, Sep 08, 2004 at 10:30:33AM -0400, James Bottomley wrote:
> > On Wed, 2004-09-08 at 09:44, Luben Tuikov wrote:
> > > Yes they are okay and James can apply them.
> > 
> > OK, could someone do a resend with changelog that applies to the current
> > tree, please.
> 
> ----
> [PATCH] add proper pci id table to aic7xxx
> 
> (trivial respin of an earlier patch by Andi Kleen)

This doesn't actually compile: aic7xxx_pci.h is missing, I think.

James


