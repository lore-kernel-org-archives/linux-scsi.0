From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v3 0/3] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Tue, 22 Mar 2016 20:32:02 +0100
Message-ID: <1458675126-19265-1-git-send-email-linux@rasmusvillemoes.dk>
References: <20160322075405.GA20141@infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33081 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbcCVTcW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 15:32:22 -0400
Received: by mail-wm0-f54.google.com with SMTP id l68so206584709wml.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2016 12:32:21 -0700 (PDT)
In-Reply-To: <20160322075405.GA20141@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>

This is mostly identical to v2 sent in November, rebased (cleanly) to
current mainline. The only change is that I've this time also updated
the Kconfig help text in 3/3, since the 75 KB was a bit
exaggerated. After these patches are applied, the impact of choosing
CONFIG_SCSI_CONSTANTS=y is about 36 KB, while it was about 44 KB
before. I took the liberty of including Hannes' Reviewed-by and
Douglas' Tested-by despite that addition.

Rasmus Villemoes (3):
  scsi: make some Additional Sense strings more grep'able
  scsi: move Additional Sense Codes to separate file
  scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k

 drivers/scsi/Kconfig       |   4 +-
 drivers/scsi/constants.c   | 859 ++-------------------------------------------
 drivers/scsi/sense_codes.h | 826 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 849 insertions(+), 840 deletions(-)
 create mode 100644 drivers/scsi/sense_codes.h

-- 
2.1.4

