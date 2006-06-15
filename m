From: Andrew Patterson <andrew.patterson@hp.com>
Subject: RE: [PATCH] Optionally disable QAS in MPT Fusion spi driver
Date: Thu, 15 Jun 2006 11:28:09 -0600
Message-ID: <1150392489.12760.153.camel@bluto.andrew>
References: <664A4EBB07F29743873A87CF62C26D70199848@NAMAIL4.ad.lsil.com>
	 <1150388463.3143.47.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:12241 "EHLO atlrel6.hp.com")
	by vger.kernel.org with ESMTP id S1030890AbWFOR2K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 13:28:10 -0400
In-Reply-To: <1150388463.3143.47.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, 2006-06-15 at 09:21 -0700, James Bottomley wrote:
> On Thu, 2006-06-15 at 09:31 -0600, Moore, Eric wrote:
> > James said it was okay for having this done in lld, instead
> > of transport.  I'm sure both me and Andrew would be happy 
> > the same if the transport handled this.  
> > Is that possible for you to look into this, or James?
> 
> Before we go the lld route, could someone just assure me this is a
> fusion specific problem.  Andrew, could you attach the same drives to
> another QAS LLD, like aic79xx and verify the problem doesn't recur?

We can only reproduce this problem at a specific site which we no longer
have access to.  At that site, we had problems with both HP OEM'd Maxtor
and Fujitsu drives.  I also don't have any other u320 cards to try this
on other than Fusion.  Eric? Have you been able to reproduce this
problem on Linux at LSI?

> 
> If it's something drive specific, we probably need more of a blacklist
> in the spi transport class.

My guess is this is a drive/fusion interaction problem. 

Andrew


