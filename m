From: Christoph Hellwig <hch@lst.de>
Subject: should we remove cpqfc from the Linux 2.6 tree?
Date: Sat, 18 Sep 2004 22:32:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040918203216.GA29460@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:30874 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269627AbUIRUcY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2004 16:32:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: chirag.kantharia@hp.com, mkp@mkp.net
Cc: iss_storagedev@hp.com, linux-scsi@vger.kernel.org

I remember mkp had some interested in reactivating that driver, is that
still true?  I'd prefer to kill it from the tree and re-merge it if
we get a sane one, but the current one is doing far to bad things that
I'd want to waste any ressources on it when moving the remaining drivers
over to the current APIs.
