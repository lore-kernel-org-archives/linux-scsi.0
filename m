From: David Miller <davem@davemloft.net>
Subject: [GIT]: ESP scsi driver.
Date: Thu, 19 Jun 2008 20:26:35 -0700 (PDT)
Message-ID: <20080619.202635.89650161.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40532
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYFTD0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2008 23:26:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org


James, please pull to get these ESP scsi driver fixes.

Thanks a lot!

The following changes since commit 9bedbcb207ed9a571b239231d99c8fd4a34ae24d:
  Dave Airlie (1):
        agp: brown paper bag patch - put back two lines that got lost

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/esp-2.6.git master

David S. Miller (2):
      esp: Fix OOPS in esp_reset_cleanup().
      esp: Correct chip ID probing sequence.

Frans Pop (1):
      esp: correct module name in Kconfig help for SCSI_SUNESP

 drivers/scsi/Kconfig    |    6 ++++--
 drivers/scsi/esp_scsi.c |   32 +++++++++++++++++++++-----------
 drivers/scsi/esp_scsi.h |    1 +
 3 files changed, 26 insertions(+), 13 deletions(-)
