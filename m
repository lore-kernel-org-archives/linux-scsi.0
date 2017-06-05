From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH] Remove white spaces from fcoe.h
Date: Mon, 5 Jun 2017 14:22:40 +0530
Message-ID: <0f8b6a7b-c1d2-bc95-7970-7572991495cb@redhat.com>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove the white spaces in do/while loop used for checking fcoe
debug logging

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/fcoe/fcoe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 6aa4820..7406376 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -46,7 +46,7 @@ extern unsigned int fcoe_debug_logging;
 #define FCOE_NETDEV_LOGGING 0x02 /* Netdevice logging */
 
 #define FCOE_CHECK_LOGGING(LEVEL, CMD)					\
-do {                                                            	\
+do {									\
 	if (unlikely(fcoe_debug_logging & LEVEL))			\
 		do {							\
 			CMD;						\
