From: Christoph Hellwig <hch@infradead.org>
Subject: scsi-misc BK tree: Fix scsi_device_get to allow NULL devices
Date: Mon, 5 Apr 2004 12:55:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405125531.A4910@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:18954 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262130AbUDELzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 07:55:35 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.30 #5 (Red Hat Linux))
	id 1BAShP-0001Hb-OS
	for linux-scsi@vger.kernel.org; Mon, 05 Apr 2004 12:55:31 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can the SuSE guys please elaborate what this patch is supposed to solve?
We should never pass a NULL pointer to scsi_device_get..
