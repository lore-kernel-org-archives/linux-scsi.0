From: Jeff Garzik <jgarzik@pobox.com>
Subject: [bk patches] move scsi headers
Date: Mon, 26 May 2003 23:42:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030527034239.GA16376@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:61121
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S263062AbTE0D31
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 May 2003 23:29:27 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


James, please do a

	bk pull bk://kernel.bkbits.net/jgarzik/scsi-misc-2.5

This will update the following files:

 drivers/scsi/hosts.h          |  603 ------------------------------------
 drivers/scsi/scsi.h           |  690 -----------------------------------------
 drivers/scsi/scsi_obsolete.h  |  106 ------
 drivers/scsi/hosts.h          |    6 
 drivers/scsi/scsi.h           |    6 
 drivers/scsi/scsi_obsolete.h  |    6 
 drivers/scsi/st.h             |    4 
 include/linux/scsi_defs.h     |  692 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/scsi_hosts.h    |  603 ++++++++++++++++++++++++++++++++++++
 include/linux/scsi_obsolete.h |  106 ++++++
 10 files changed, 1419 insertions(+), 1403 deletions(-)

through these ChangeSets:

<jgarzik@redhat.com> (03/05/26 1.1195)
   [scsi] add drivers/scsi/{scsi,hosts,scsi_obsolete}.h wrappers
   
   Also, remove "#ifndef _SCSI_H" from st.h, and
   include linux/scsi_obsolete.h rather than "scsi_obsolete.h"
   in linux/scsi_defs.h.

<jgarzik@redhat.com> (03/05/26 1.1194)
   [scsi] mv drv/scsi/{scsi,hosts,scsi_obsolete}.h to include/linux
   
   New names:
   include/linux/scsi_hosts.h
   include/linux/scsi_defs.h
   include/linux/scsi_obsolete.h

