From: domen@coderock.org
Subject: [patch 3/3] drivers/scsi/qla2xxx/*: convert to pci_register_driver
Date: Sun, 06 Mar 2005 23:28:02 +0100
Message-ID: <20050306222802.B81391ED3D@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:1455 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261540AbVCFW2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:28:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, c.lucas@ifrance.com


convert from pci_module_init to pci_register_driver
(from:http://kerneljanitors.org/TODO).

Signed-off-by: Christophe Lucas <c.lucas@ifrance.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/qla2xxx/ql2100.c |    2 +-
 kj-domen/drivers/scsi/qla2xxx/ql2200.c |    2 +-
 kj-domen/drivers/scsi/qla2xxx/ql2300.c |    2 +-
 kj-domen/drivers/scsi/qla2xxx/ql2322.c |    2 +-
 kj-domen/drivers/scsi/qla2xxx/ql6312.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/qla2xxx/ql2100.c~pci_register_driver-drivers_scsi_qla2xxx drivers/scsi/qla2xxx/ql2100.c
--- kj/drivers/scsi/qla2xxx/ql2100.c~pci_register_driver-drivers_scsi_qla2xxx	2005-03-05 16:12:53.000000000 +0100
+++ kj-domen/drivers/scsi/qla2xxx/ql2100.c	2005-03-05 16:12:53.000000000 +0100
@@ -74,7 +74,7 @@ static struct pci_driver qla2100_pci_dri
 static int __init
 qla2100_init(void)
 {
-	return pci_module_init(&qla2100_pci_driver);
+	return pci_register_driver(&qla2100_pci_driver);
 }
 
 static void __exit
diff -puN drivers/scsi/qla2xxx/ql2200.c~pci_register_driver-drivers_scsi_qla2xxx drivers/scsi/qla2xxx/ql2200.c
--- kj/drivers/scsi/qla2xxx/ql2200.c~pci_register_driver-drivers_scsi_qla2xxx	2005-03-05 16:12:53.000000000 +0100
+++ kj-domen/drivers/scsi/qla2xxx/ql2200.c	2005-03-05 16:12:53.000000000 +0100
@@ -74,7 +74,7 @@ static struct pci_driver qla2200_pci_dri
 static int __init
 qla2200_init(void)
 {
-	return pci_module_init(&qla2200_pci_driver);
+	return pci_register_driver(&qla2200_pci_driver);
 }
 
 static void __exit
diff -puN drivers/scsi/qla2xxx/ql2300.c~pci_register_driver-drivers_scsi_qla2xxx drivers/scsi/qla2xxx/ql2300.c
--- kj/drivers/scsi/qla2xxx/ql2300.c~pci_register_driver-drivers_scsi_qla2xxx	2005-03-05 16:12:53.000000000 +0100
+++ kj-domen/drivers/scsi/qla2xxx/ql2300.c	2005-03-05 16:12:53.000000000 +0100
@@ -85,7 +85,7 @@ static struct pci_driver qla2300_pci_dri
 static int __init
 qla2300_init(void)
 {
-	return pci_module_init(&qla2300_pci_driver);
+	return pci_register_driver(&qla2300_pci_driver);
 }
 
 static void __exit
diff -puN drivers/scsi/qla2xxx/ql2322.c~pci_register_driver-drivers_scsi_qla2xxx drivers/scsi/qla2xxx/ql2322.c
--- kj/drivers/scsi/qla2xxx/ql2322.c~pci_register_driver-drivers_scsi_qla2xxx	2005-03-05 16:12:53.000000000 +0100
+++ kj-domen/drivers/scsi/qla2xxx/ql2322.c	2005-03-05 16:12:53.000000000 +0100
@@ -90,7 +90,7 @@ static struct pci_driver qla2322_pci_dri
 static int __init
 qla2322_init(void)
 {
-	return pci_module_init(&qla2322_pci_driver);
+	return pci_register_driver(&qla2322_pci_driver);
 }
 
 static void __exit
diff -puN drivers/scsi/qla2xxx/ql6312.c~pci_register_driver-drivers_scsi_qla2xxx drivers/scsi/qla2xxx/ql6312.c
--- kj/drivers/scsi/qla2xxx/ql6312.c~pci_register_driver-drivers_scsi_qla2xxx	2005-03-05 16:12:53.000000000 +0100
+++ kj-domen/drivers/scsi/qla2xxx/ql6312.c	2005-03-05 16:12:53.000000000 +0100
@@ -84,7 +84,7 @@ static struct pci_driver qla6312_pci_dri
 static int __init
 qla6312_init(void)
 {
-	return pci_module_init(&qla6312_pci_driver);
+	return pci_register_driver(&qla6312_pci_driver);
 }
 
 static void __exit
_
