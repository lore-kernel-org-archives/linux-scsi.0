From: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Subject: RE: [PATCH] cciss 2.6: pci domain info
Date: Fri, 17 Jun 2005 14:40:16 -0500
Message-ID: <D4CFB69C345C394284E4B78B876C1CF107DC07D8@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:38031 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S262079AbVFQTkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2005 15:40:35 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Christoph wrote:
> 
> On Fri, Jun 17, 2005 at 01:31:24PM -0500, mike.miller@hp.com wrote:
> > This patch adds pci domain info to our CCISS_GETPCIINFO 
> ioctl. This is to support the next generation of Itanium 
> platforms. We had a couple of spare bytes in the structure. 
> Impact to existing apps should be minimal. Please consider 
> this patch for inclusion.
> 
> I don't think an unsigned int fits into padding of any platform.

How about 'unsigned short' as Willy suggested?

mikem
