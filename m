From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o pci_driver model
Date: Tue, 6 Sep 2005 08:28:12 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F018BD34C@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:10172 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964818AbVIFM2O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2005 08:28:14 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig writes:

> On Fri, Aug 19, 2005 at 11:05:41AM -0400, Salyzyn, Mark wrote:
> > The sysinit structure is supposed to be a complete list of all
peered 
> > i2o adapters. The current driver structure issued the sysinit
command 
> > after all adapters were discovered rather than re-issuing as each
was 
> > added.
> Yeah, I noticed that, but the question is why that's nessecary, after
all the i2o layer drivers don't need that either.

Strictly no longer required, even our multi-controller failover software
made alternate daemon application arrangements for inter-card
communications (cache synchronization). Cross Adapter RAID was dropped
in 1998. It was merely a pedantic continuation of this support.

As I indicated (and once I have time) I will recode the paths to
instantiate the adapters individually.

-- Mark Salyzyn
