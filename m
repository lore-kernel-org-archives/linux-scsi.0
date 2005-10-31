From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/4] remove Scsi_ typedefs
Date: Mon, 31 Oct 2005 18:31:27 +0100
Message-ID: <20051031173127.GA14182@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:17310 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964795AbVJaRba (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 12:31:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Jeff agreed on killing them post-2.6.14 so here we go.
I'm not killing Scsi_Request because we'll hopefulyl get rid of the
underlying type before 2.6.15.
