From: "Adam Radford" <aradford@amcc.com>
Subject: RE: 3w-xxxx updates
Date: Mon, 21 Jun 2004 14:11:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <HZOG7T01.NS0@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:33448 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S266473AbUFUVLz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 17:11:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Yes, I am definately going to be updating the 3w-xxxx driver in 2.6 to
convert it to the new pci driver interface / remove obsolete scsi interfaces.

-Adam

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de]
Sent: Sunday, June 20, 2004 8:37 AM
To: aradford@amcc.com
Cc: linux-scsi@vger.kernel.org
Subject: 3w-xxxx updates


Hi Adam,

after you got the new 3w-9xxx driver so nicely in shape is there any
chance you could do some of that to the old 3ware driver, too?  We'd
like to move all scsi drivers to the modern hotplug pci driver interface
and get rid of the obsolete scsi interfaces (#include "scsi.h") at
least.

