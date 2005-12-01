From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 4/5] aacraid: better sysfs adapter information
Date: Thu, 1 Dec 2005 13:26:22 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E9A86A@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:47521 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932393AbVLAS0X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 13:26:23 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] sez:
> Ok, makes sense.  Can we now get rid of the huge table of 
> product names in linit.c?

I would have to do an audit on all the cards to discover which ones have
override information and which do not. As I do not have all cards, all
firmware, all variants in my hands at all times, I would consider it
risky at the moment. Quite a few of the '9005 0285' and '9005 0286'
specific entries could be squashed down to a small handful of more
generic ones, once that audit has taken place. QUIRK's nothwithstanding.
All the legacy Dell, HP, Legend & some of the Adaptec cards would
necessarily remain.

What can happen, though, is that we can in the future stop making
changes to linit.c for every new product and continue to focus on
updating just the pciids.sourceforge.net &
Documentation/scsi/aacraid.txt (soon to be formerly
drivers/scsi/aacraid/README) to list the supported products.

Sincerely -- Mark Salyzyn
