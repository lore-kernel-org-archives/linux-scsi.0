From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 1/3] [SCSI] aic7xxx: mark ahd_pci_ident_table and ahd_num_pci_devs static
Date: Tue, 26 Sep 2006 10:06:52 +0200
Message-ID: <1159258012251@messid.opensource.sf-tec.de>
References: <11592580111076@messid.opensource.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51906 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1750785AbWIZIGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 04:06:14 -0400
In-Reply-To: <11592580111076@messid.opensource.sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

[SCSI] aic7xxx: mark ahd_pci_ident_table and ahd_num_pci_devs static

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit c083dac8517da8e3a2b0dfa1e2ac9166638cfc76
tree 5b568d88875ff46634752dd3889ed968f0543fc2
parent d3df850ce80c56524cdb7d31695d04490b7d012b
author Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 06 Jul 2006 13:31:23 +0200
committer Rolf Eike Beer <beer@siso-eb-i34d.silicon-software.de> Thu, 06 Jul 2006 14:17:15 +0200

 drivers/scsi/aic7xxx/aic79xx.h     |    2 --
 drivers/scsi/aic7xxx/aic79xx_pci.c |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index df3346b..d3b93cc 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -1320,8 +1320,6 @@ struct ahd_pci_identity {
 	char			*name;
 	ahd_device_setup_t	*setup;
 };
-extern struct ahd_pci_identity ahd_pci_ident_table [];
-extern const u_int ahd_num_pci_devs;
 
 /***************************** VL/EISA Declarations ***************************/
 struct aic7770_identity {
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 14850f3..c95f06b 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -97,7 +97,7 @@ static ahd_device_setup_t ahd_aic7901A_s
 static ahd_device_setup_t ahd_aic7902_setup;
 static ahd_device_setup_t ahd_aic790X_setup;
 
-struct ahd_pci_identity ahd_pci_ident_table [] =
+static const struct ahd_pci_identity ahd_pci_ident_table [] =
 {
 	/* aic7901 based controllers */
 	{
@@ -201,7 +201,7 @@ struct ahd_pci_identity ahd_pci_ident_ta
 	}
 };
 
-const u_int ahd_num_pci_devs = ARRAY_SIZE(ahd_pci_ident_table);
+static const u_int ahd_num_pci_devs = ARRAY_SIZE(ahd_pci_ident_table);
 		
 #define	DEVCONFIG		0x40
 #define		PCIXINITPAT	0x0000E000ul

