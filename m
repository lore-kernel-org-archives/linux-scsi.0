From: Christoph Hellwig <hch@lst.de>
Subject: eh_active checks in qla2xxx error handling
Date: Tue, 6 Sep 2005 14:20:28 +0200
Message-ID: <20050906122028.GA22963@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:47493 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964782AbVIFMUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 08:20:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

qla2xxx is the only driver looking at eh_active, and doing the wait
for oustanding commands only from EH thread resets but not from the
ioctls looks rather wrong to me.  Do you remember the rational for it?
