From: Luis de Bethencourt <luisbg@kernel.org>
Subject: [PATCH] tcmu: Fix trailing semicolon
Date: Tue, 16 Jan 2018 15:34:32 +0000
Message-ID: <20180116153432.17927-1-luisbg@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:19139 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbeAPPfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jan 2018 10:35:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, "Nicholas A . Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Luis de Bethencourt <luisbg@kernel.org>

The trailing semicolon is an empty statement that does no operation.
It is completely stripped out by the compiler. Removing it since it doesn't do
anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
---

Hi,

After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
suggested I fix it treewide [0].

Best regards 
Luis


[0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html

 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 60c8a87b7a88..f6164d294fb3 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1564,7 +1564,7 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 
 	wake_up_all(&udev->nl_cmd_wq);
 
-	return ret;;
+	return ret;
 }
 
 static int tcmu_netlink_event(struct tcmu_dev *udev, enum tcmu_genl_cmd cmd,
-- 
2.15.1
