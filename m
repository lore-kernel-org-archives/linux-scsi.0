From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: message: fusion: fix a few trivial spelling mistakes
Date: Sun,  9 Sep 2018 23:17:34 +0100
Message-ID: <20180909221734.8047-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trival fix to spelling mistakes:
PrimativeSeqErrCount -> PrimitiveSeqErrCount
Broadcase -> Broadcast
Primative -> Primitive

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/message/fusion/lsi/mpi_cnfg.h | 2 +-
 drivers/message/fusion/mptbase.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index 059997f8ebce..178f414ea8f9 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -2004,7 +2004,7 @@ typedef struct _CONFIG_PAGE_FC_PORT_6
     U64                     LinkFailureCount;           /* 50h */
     U64                     LossOfSyncCount;            /* 58h */
     U64                     LossOfSignalCount;          /* 60h */
-    U64                     PrimativeSeqErrCount;       /* 68h */
+    U64                     PrimitiveSeqErrCount;       /* 68h */
     U64                     InvalidTxWordCount;         /* 70h */
     U64                     InvalidCrcCount;            /* 78h */
     U64                     FcpInitiatorIoCount;        /* 80h */
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e6b4ae558767..2b1ea7f8031d 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7572,7 +7572,7 @@ mpt_display_event_info(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply)
 		u8 port_width = (u8)(evData0 >> 16);
 		u8 primative = (u8)(evData0 >> 24);
 		snprintf(evStr, EVENT_DESCR_STR_SZ,
-		    "SAS Broadcase Primative: phy=%d port=%d "
+		    "SAS Broadcast Primitive: phy=%d port=%d "
 		    "width=%d primative=0x%02x",
 		    phy_num, port_num, port_width, primative);
 		break;
-- 
2.17.1
