From: Christoph Hellwig <hch@lst.de>
Subject: megaraid_sas: sparse annotations and endianess fixes
Date: Sat, 10 Jan 2015 18:11:13 +0100
Message-ID: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34170 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbbAJRMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

The first 8 are fairly mechanical, but the last two will need close
inspection.  There's also a huge mess around the fw ioctls left, which
I haven't really made much progress on as they are way too convoluted.

