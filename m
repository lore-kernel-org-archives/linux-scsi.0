From: Eugene Teo <eugeneteo@kernel.sg>
Subject: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile
	error
Date: Wed, 1 Aug 2007 21:39:12 +0800
Message-ID: <20070801133912.GA11027@kernel.sg>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.224]:14145 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbXHANkm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 09:40:42 -0400
Received: by qb-out-0506.google.com with SMTP id e11so203462qbe
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 06:40:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <46B0842D.3060703@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Gabriel,

Hope the following trivial patch helps.

<quote sender="Gabriel C">
> Getting this with a randconfig ( http://194.231.229.228/MM/randconfig-auto-10 )
> 
[...]
> drivers/scsi/advansys.c:794:2: warning: #warning this driver is still not properly converted to the DMA API
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:17781: error: implicit declaration of function 'to_pci_dev'
[...]

This patch fixes the following compile error:

drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:17781: error: implicit declaration of function
'to_pci_dev'

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/scsi/advansys.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 79c0b6e..908f02b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -774,6 +774,7 @@
 #include <linux/stat.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
+#include <linux/pci.h>
 
 #include <asm/io.h>
 #include <asm/system.h>

