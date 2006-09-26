From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 2/3] [SCSI] remove extra newline from info message
Date: Tue, 26 Sep 2006 10:06:52 +0200
Message-ID: <1159258012737@messid.opensource.sf-tec.de>
References: <11592580111076@messid.opensource.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:53698 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1750759AbWIZIGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 04:06:13 -0400
In-Reply-To: <11592580111076@messid.opensource.sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

[SCSI] remove extra newline from info message

This extra newline character introduces a completely empty line in dmesg as
the calling function itself adds a newline.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit fdae83cc4c0e84e19609688c439a87083b816414
tree cd73ce0abcbee1ff4844b29e9427c8115b45dee8
parent c083dac8517da8e3a2b0dfa1e2ac9166638cfc76
author Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 06 Jul 2006 13:42:46 +0200
committer Rolf Eike Beer <beer@siso-eb-i34d.silicon-software.de> Thu, 06 Jul 2006 14:17:15 +0200

 drivers/scsi/aic7xxx/aic79xx_osm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index b244c71..6c9608c 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -418,7 +418,6 @@ ahd_linux_info(struct Scsi_Host *host)
 	strcat(bp, "        ");
 	ahd_controller_info(ahd, ahd_info);
 	strcat(bp, ahd_info);
-	strcat(bp, "\n");
 
 	return (bp);
 }

