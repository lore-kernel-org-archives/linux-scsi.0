From: Christoph Hellwig <hch@lst.de>
Subject: 3w-xxxx updates
Date: Sun, 20 Jun 2004 17:37:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040620153700.GA16917@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:50877 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265006AbUFTPhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 11:37:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: aradford@amcc.com
Cc: linux-scsi@vger.kernel.org

Hi Adam,

after you got the new 3w-9xxx driver so nicely in shape is there any
chance you could do some of that to the old 3ware driver, too?  We'd
like to move all scsi drivers to the modern hotplug pci driver interface
and get rid of the obsolete scsi interfaces (#include "scsi.h") at
least.
