From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Removing the qlogicfc driver
Date: 16 Jan 2004 11:49:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074271764.1814.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:44167 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265632AbUAPQt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 11:49:27 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i0GGnQa17469
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2004 11:49:26 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Now that the qla2xxx driver is in the kernel, I don't see any reason to
keep the qlogicfc driver hanging around.

Unless anyone has a good reason why not, I'll remove it in the next SCSI
patch set.

James



