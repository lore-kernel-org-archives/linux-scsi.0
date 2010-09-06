From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: [PATCH 08/14] drivers/scsi: Removing undead ifdef CONFIG_PCI
Date: Mon, 6 Sep 2010 16:36:36 +0200
Message-ID: <7b18a70423acd7cdae3a8d6ae636b99e202acc64.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33588 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab0IFOgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 10:36:38 -0400
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de

The CONFIG_PCI ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/scsi/aic7xxx_old.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 93984c9..c0953be 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -9655,9 +9655,7 @@ aic7xxx_detect(struct scsi_host_template *template)
           found++;
 	  continue;
 skip_pci_controller:
-#ifdef CONFIG_PCI
 	  pci_release_regions(temp_p->pdev);
-#endif
 	  kfree(temp_p);
         }  /* Found an Adaptec PCI device. */
         else /* Well, we found one, but we couldn't get any memory */
-- 
1.7.0.4

