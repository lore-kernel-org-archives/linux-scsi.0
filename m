From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: fusion: fix spelling mistake: "Persistancy" -> "Persistency"
Date: Sat, 22 Apr 2017 14:02:02 +0100
Message-ID: <20170422130202.10386-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/message/fusion/mptbase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 1e73064b0fb2..62cff5afc6bd 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7396,7 +7396,7 @@ mpt_display_event_info(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply)
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: No Persistancy: "
+			    "SAS Device Status Change: No Persistency: "
 			    "id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED:
-- 
2.11.0
