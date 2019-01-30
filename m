From: Joao Pinto <joao.pinto@synopsys.com>
Subject: [PATCH for-next] scsi: ufs: Update dwc driver maintainer to Pedro Sousa
Date: Wed, 30 Jan 2019 18:48:13 +0100
Message-ID: <812e9e1426555808ad1bd5fbfda320c6684abc81.1548869844.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: joao.pinto@synopsys.com, pedrom.sousa@synopsys.com, marc.w.gonzalez@free.fr, Alex.Lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

Currently I am managing the Synopsys drivers & tools team (full-time) and
so I am passing the DWC UFS driver maintenance to Pedro Sousa.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Cc: Pedro Sousa <pedrom.sousa@synopsys.com>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Alex Lemberg <Alex.Lemberg@wdc.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 70c93b1..458a2a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15673,7 +15673,7 @@ F:	Documentation/scsi/ufs.txt
 F:	drivers/scsi/ufs/
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
-M:	Joao Pinto <jpinto@synopsys.com>
+M:	Pedro Sousa <pedrom.sousa@synopsys.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ufs/*dwc*
-- 
2.7.4
