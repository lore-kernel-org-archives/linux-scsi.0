From: Christoph Hellwig <hch@lst.de>
Subject: please revert [PATCH] s390: zfcp act enhancements
Date: Tue, 16 Nov 2004 09:53:33 +0100
Message-ID: <20041116085333.GA2652@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:47019 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261941AbUKPIxh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 03:53:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, schwidefsky@de.ibm.com
Cc: linux390@de.ibm.com, linux-scsi@vger.kernel.org

That cset is adding tons of not used intree exports to the zfcp driver,
for an IBM module for an API (SNIA HBA API) that we as we as the scsi
team have rejected.

If IBM wants to support a managment API for their FC adapter they should
participate in the FC transport class development.

I also want to protest that IBM sends scsi LLDD updates not via
linux-scsi *AGAIN*.
