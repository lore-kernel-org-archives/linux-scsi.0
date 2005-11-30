From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 4/5] aacraid: better sysfs adapter information
Date: Wed, 30 Nov 2005 14:35:41 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E146@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54936 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751520AbVK3Tfm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:35:42 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:
> > Provide more accurate adapter information.
> so what information is this going to print now? do you have 
> an example?

This change empowers the Firmware.

This allows the Adapter Firmware to override the Adapter product
information. The information before this modification was table driven
by the PCI Product ID.

In some cases the change is merely for OEMization (IBM 8i or ADAPTEC
4005SAS), in other cases we have the 'family' match that permits the
driver to attach to all future adapters, and without this change the
Adapter would be designated the mundane name of "ADAPTEC RAID" rather
than the name that the Firmware reports.

-- Mark Salyzyn 
