From: Matthew Wilcox <willy@debian.org>
Subject: Documentation
Date: Fri, 6 Jun 2003 14:20:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606132054.GZ28581@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:48537 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261411AbTFFNHV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 09:07:21 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.14)
	id 19OH9L-0004WY-1Q
	for linux-scsi@vger.kernel.org; Fri, 06 Jun 2003 14:20:55 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Kconfig's in pretty good shape now from a structural point of view,
so I thought I'd review some of the actual help text.

Many entries refer to the ancient SCSI-HOWTO.  It doesn't
seemto be on tldp.org anywhere, but I found it at
http://www.ibiblio.org/pub/Linux/docs/HOWTO/unmaintained/SCSI-HOWTO

Do we want to correct the URL from http://www.tldp.org/docs.html#howto
to the one above or excise all references to it?

The Disk-HOWTO, Multi-Disk-HOWTO, and CD-ROM-HOWTO are also referenced.
The Disk-HOWTO has also disappeared.  The Multi-Disk-HOWTO doesn't really
seem relevant at this point.  Though the CD-ROM-HOWTO is listed as the
CDROM-HOWTO, it still seems relevant.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
