From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH v2 7/8] PM / Runtime: Add can_power_off flag to subsys data
Date: Thu,  1 Mar 2012 17:02:56 +0800
Message-ID: <1330592577-16546-8-git-send-email-ming.m.lin@intel.com>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Parent device will check child's can_power_off flag to see if child device can
be powered off.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/pm.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index e4982ac..2e74531 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -465,6 +465,7 @@ struct pm_subsys_data {
 #ifdef CONFIG_PM_GENERIC_DOMAINS
 	struct pm_domain_data *domain_data;
 #endif
+	bool can_power_off;
 };
 
 struct dev_pm_info {
-- 
1.7.2.5
