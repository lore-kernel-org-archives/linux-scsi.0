From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH v2 0/3] g_NCR5380: Modernization
Date: Tue, 27 Sep 2016 21:00:22 +0200
Message-ID: <1475002825-18132-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:60322 "EHLO gsystem.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbcI0TAp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 15:00:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


This small patch series removes deprecated code from g_NCR5380 driver
and converts it from scsi_module.c to scsi_add_host().

Tested with:
HP C2502 (53C400A chip)
Canon FG2-5202 (53C400 chip, memory-mapped)
DTC-3181L (DTCT-436P chip, PnP)

---
Changes in v2: 
 - updated Documentation/scsi/g_NCR5380.txt
 - kept old-style module parameters for compatibility
 - added missing NCR5380_exit() call
 - fixed error propagation from init
 - simplified driver registration

-- 
Ondrej Zary
