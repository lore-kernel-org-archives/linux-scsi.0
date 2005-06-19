From: "David S. Miller" <davem@davemloft.net>
Subject: recent scsi changes break fc4 build
Date: Sat, 18 Jun 2005 23:16:46 -0700 (PDT)
Message-ID: <20050618.231646.91312440.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:25472
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S262042AbVFSGRR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 02:17:17 -0400
Received: from localhost ([127.0.0.1] ident=davem)
	by sunset.davemloft.net with esmtp (Exim 4.50)
	id 1Djt6s-0003aL-JX
	for linux-scsi@vger.kernel.org; Sat, 18 Jun 2005 23:16:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Please, at the very least, try to compile the changes you send the
Linus instead of doing a cut&paste job and hoping for the best.

Thanks a lot.

drivers/fc4/fc.c: In function `fcp_scsi_done':
drivers/fc4/fc.c:768: warning: unused variable `flags'
drivers/fc4/fc.c: In function `fcp_scsi_abort':
drivers/fc4/fc.c:910: warning: unused variable `flags'
drivers/fc4/fc.c: In function `fcp_scsi_dev_reset':
drivers/fc4/fc.c:987: error: `flags' undeclared (first use in this function)
drivers/fc4/fc.c:987: error: (Each undeclared identifier is reported only once
drivers/fc4/fc.c:987: error: for each function it appears in.)
drivers/fc4/fc.c: In function `fcp_scsi_host_reset':
drivers/fc4/fc.c:1033: error: `flags' undeclared (first use in this function)
