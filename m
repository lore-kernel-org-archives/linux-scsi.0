From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Adaptec 2200S with aacraid won't do 64-bit
Date: Wed, 23 Feb 2005 08:15:45 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BCDC7B5@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:17833 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261486AbVBWNPt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 08:15:49 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Tim Wesemann <timuel@voicenet.com>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox write:
> That sounds like the bus is in single-ended mode (which is limited to 
> 40MB/s) rather than LVD.  Check cabling, terminators, etc.

This is the more likely scenario regarding the limits in performance.
The CHIM in the card's Firmware is different than the PD CHIM in the
Linux 7902A drivers, so there may even be a device incompatibility with
the 2200S that differs from the SCSI driver. The Domain Validation could
be affected, selecting a less than optimal communications to the drives.
I would recommend contacting Adaptec Technical Support to ensure that
the Drive Type and Drive (and controller) Firmware is compatible.

Sincerely -- Mark Salyzyn
