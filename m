From: Christoph Hellwig <hch@lst.de>
Subject: future of drivers/fc4/
Date: Sun, 20 Jun 2004 18:03:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040620160353.GA17163@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:702 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264983AbUFTQDy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 12:03:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

The SUN FCAL support has been non-working for ages and needs major work
to keep up with scsi API changes.  Is anyone planning to ressurect it
midterm?  If not I'd like to remove it from the tree.
