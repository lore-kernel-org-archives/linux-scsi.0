From: Christoph Hellwig <hch@lst.de>
Subject: GFDL issue in Documentation/DocBook/scsidrivers.tmpl
Date: Thu, 7 Aug 2003 18:25:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807162521.GA30904@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:19417 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S270326AbTHGQZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Aug 2003 12:25:26 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

As discussed in the thread at
http://www.ussg.iu.edu/hypermail/linux/kernel/0306.1/1928.html
we agreed that GFDL is not an acceptable license for documentation
in the kernel tree, but file in subject still comes under that
license.

Douglas, any chance you could relicense it under something
GPL-compatible?  It probably wants folding into scsi_mid_low_api.txt
anyway..
