From: Prabu Thangamuthu <Prabu.T@synopsys.com>
Subject: [PATCH 1/1] scsi: ufs: changing maintainer
Date: Tue, 18 Jul 2017 09:15:58 +0000
Message-ID: <705D14B1C7978B40A723277C067CEDE2010A73580C@IN01WEMBXB.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Greg Kroah-Hartman (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@kernel.org>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Manjunath M Bettegowda <Manjunath.MB@synopsys.com>, Carlos Palminha <CARLOS.PALMINHA@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

As per internal decision, Joao Pinto will be maintainer for DWC UFS driver.

Signed-off-by: Prabu Thangamuthu <prabut@synopsys.com>
---
 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a99f6b..2122e93 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13548,8 +13548,7 @@ F:	Documentation/scsi/ufs.txt
 F:	drivers/scsi/ufs/
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
-M:	Manjunath M Bettegowda <manjumb@synopsys.com>
-M:	Prabu Thangamuthu <prabut@synopsys.com>
+M:	Joao Pinto <jpinto@synopsys.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ufs/*dwc*
-- 
1.7.9.5
