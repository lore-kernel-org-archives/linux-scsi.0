From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/5]wireless:hostap_main.c warning: variable 'iface' set but not used
Date: Tue, 15 Jun 2010 22:33:50 -0700
Message-ID: <1276666434-11227-2-git-send-email-justinmattock@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The patch below fixes a warning message Im seeing with gcc 4.6.0
 CC [M]  drivers/net/wireless/hostap/hostap_main.o
drivers/net/wireless/hostap/hostap_main.c: In function 'hostap_set_multicast_list_queue':
drivers/net/wireless/hostap/hostap_main.c:744:27: warning: variable 'iface' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/hostap/hostap_main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index eb57d1e..eaee84b 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -741,9 +741,7 @@ void hostap_set_multicast_list_queue(struct work_struct *work)
 	local_info_t *local =
 		container_of(work, local_info_t, set_multicast_list_queue);
 	struct net_device *dev = local->dev;
-	struct hostap_interface *iface;
 
-	iface = netdev_priv(dev);
 	if (hostap_set_word(dev, HFA384X_RID_PROMISCUOUSMODE,
 			    local->is_promisc)) {
 		printk(KERN_INFO "%s: %sabling promiscuous mode failed\n",
-- 
1.7.1.rc1.21.gf3bd6
