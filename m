From: Andrew Morton <akpm@osdl.org>
Subject: drivers/scsi/megaraid/Kconfig.megaraid
Date: Wed, 18 Aug 2004 22:53:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040818225359.73da69b0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:27867 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265910AbUHSFzj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 01:55:39 -0400
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i7J5ta121717
	for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2004 22:55:37 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Could someone please fix this up?

- MEGARAID_NEWGEN and MEGARAID_MM are defaulting to `y' and `m'.  Please
  make them `n'.

- What's the `$' in here for?

	config MEGARAID_MAILBOX
		tristate "LSI Logic MegaRAID Driver (New Driver)"
		depends on PCI && SCSI && MEGARAID_MM
		default $MEGARAID_MM

- The if/endif in there can surely be replaced via proper Kconfig expressions?

