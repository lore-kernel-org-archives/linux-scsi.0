From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] killing the AMD53C974 and mac_NCR5380 drivers
Date: Sun, 1 Feb 2004 17:08:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201160801.GA15020@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:17836 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265390AbUBAQID (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2004 11:08:03 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Anyone screaming loudly if we remove them?

 - AMD53C974 is broken and doesn't even compile, all supported hardware is
   handled by the mainted tmscsim driver.
 - mac_NCR5380 isn't even referenced in the build and hasn't been at
   least since 2.4
                           
