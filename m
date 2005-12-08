From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 8 Dec 2005 08:57:15 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01EE9D15@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17846 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932105AbVLHN5Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 08:57:25 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

Christoph Hellwig writes:
> Why oh why do our chipset friends at intel have to fuck up 
> everything they can?  I wish they'd learn a lesson or two from their
cpu collegues.

The patch doesn't look like too much of a hack, pretty clean
implementation in support of a hot-swap of an adapter using ACPI hooks.
It is not specific to x86 platforms. I'd prefer that it looked more like
a suspend/resume interface rather than a raw ACPI event.

There needs to be a power management interface to SCSI and to the LLD's
in support of hot-swap of PCI attached devices. Otherwise you are asking
for the driver to be blindsided on any platform that supports this
necessary service feature.

Sincerely -- Mark Salyzyn
