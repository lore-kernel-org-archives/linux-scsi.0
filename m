From: Andrew Morton <akpm@osdl.org>
Subject: Fw: Fusion-MPT much faster as module
Date: Tue, 8 Mar 2005 17:39:51 -0800
Message-ID: <20050308173951.7338c846.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:19089 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262288AbVCIBkU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2005 20:40:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>



Begin forwarded message:

Date: Tue, 8 Mar 2005 13:38:07 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Fusion-MPT much faster as module


Hello

On a four CPU Opteron compiling the Fusion-MPT as module gives much better
performance when compiling it in, here some bonnie++ results:

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
compiled in  15872M 38366 71  65602  22 18348   4 53276 84  57947   7 905.4   2
module       15872M 51246 96 204914  70 57236  14 59779 96 264171  33 923.0   2

This happens with 2.6.10, 2.6.11 and 2.6.11-bk2. Controller is a
Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI.

Why is there such a large difference?

Holger
-- 
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
