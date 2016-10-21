From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH] scsi: ufs: changing authors e-mail
Date: Fri, 21 Oct 2016 10:33:21 +0100
Message-ID: <d7b122c23645a6e97fcacdf3b62b27b7b7add59b.1477042106.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

Although I am leaving Synopsys, I would like to keep working with the
linux kernel community and help in what you might find useful. For that
I am sending this patch to change my contact e-mail. 

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
 drivers/scsi/ufs/tc-dwc-g210-pci.c    | 4 ++--
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c | 4 ++--
 drivers/scsi/ufs/tc-dwc-g210.c        | 4 ++--
 drivers/scsi/ufs/tc-dwc-g210.h        | 2 +-
 drivers/scsi/ufs/ufshcd-dwc.c         | 4 ++--
 drivers/scsi/ufs/ufshcd-dwc.h         | 2 +-
 drivers/scsi/ufs/ufshci-dwc.h         | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index c09a0fe..13b9e6c 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
- * Authors: Joao Pinto <jpinto@synopsys.com>
+ * Authors: Joao Pinto <jpmpinto@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -176,6 +176,6 @@ static void tc_dwc_g210_pci_remove(struct pci_dev *pdev)
 
 module_pci_driver(tc_dwc_g210_pci_driver);
 
-MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_AUTHOR("Joao Pinto <jpmpinto@gmail.com>");
 MODULE_DESCRIPTION("Synopsys Test Chip G210 PCI glue driver");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
index 2d3f527..89166a9 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
- * Authors: Joao Pinto <jpinto@synopsys.com>
+ * Authors: Joao Pinto <jpmpinto@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -109,5 +109,5 @@ static int tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
 
 MODULE_ALIAS("platform:tc-dwc-g210-pltfm");
 MODULE_DESCRIPTION("Synopsys Test Chip G210 platform glue driver");
-MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_AUTHOR("Joao Pinto <jpmpinto@gmail.com>");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
index dc03e47..aeff7ff 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs/tc-dwc-g210.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
- * Authors: Joao Pinto <jpinto@synopsys.com>
+ * Authors: Joao Pinto <jpmpinto@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -315,6 +315,6 @@ int tc_dwc_g210_config_20_bit(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL(tc_dwc_g210_config_20_bit);
 
-MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_AUTHOR("Joao Pinto <jpmpinto@gmail.com>");
 MODULE_DESCRIPTION("Synopsys G210 Test Chip driver");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/tc-dwc-g210.h b/drivers/scsi/ufs/tc-dwc-g210.h
index fb177db..3ec4373 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.h
+++ b/drivers/scsi/ufs/tc-dwc-g210.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
- * Authors: Joao Pinto <jpinto@synopsys.com>
+ * Authors: Joao Pinto <jpmpinto@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/scsi/ufs/ufshcd-dwc.c
index 5fd16c7..28bd3a3 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.c
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
- * Authors: Joao Pinto <jpinto@synopsys.com>
+ * Authors: Joao Pinto <jpmpinto@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -149,6 +149,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 }
 EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
 
-MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_AUTHOR("Joao Pinto <jpmpinto@gmail.com>");
 MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/ufshcd-dwc.h b/drivers/scsi/ufs/ufshcd-dwc.h
index c8be295..0bbad1b 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.h
+++ b/drivers/scsi/ufs/ufshcd-dwc.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
- * Authors: Joao Pinto <jpinto@synopsys.com>
+ * Authors: Joao Pinto <jpmpinto@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/scsi/ufs/ufshci-dwc.h b/drivers/scsi/ufs/ufshci-dwc.h
index ca341fe..1b31330 100644
--- a/drivers/scsi/ufs/ufshci-dwc.h
+++ b/drivers/scsi/ufs/ufshci-dwc.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
- * Authors: Joao Pinto <jpinto@synopsys.com>
+ * Authors: Joao Pinto <jpmpinto@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.8.1.5
