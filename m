From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/fc4/fc.c in git-scsi-misc
Date: Thu, 11 Oct 2007 02:52:03 -0700
Message-ID: <20071011025203.e95690ee.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbXJKJwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 05:52:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

davem won't be happy

drivers/fc4/fc.c: In function `fcp_scsi_receive':
drivers/fc4/fc.c:397: error: structure has no member named `done'
drivers/fc4/fc.c:450: error: structure has no member named `done'
drivers/fc4/fc.c: In function `fcp_scsi_queuecommand':
drivers/fc4/fc.c:837: error: structure has no member named `done'
drivers/fc4/fc.c:838: error: structure has no member named `done'
drivers/fc4/fc.c:839: error: structure has no member named `done'
