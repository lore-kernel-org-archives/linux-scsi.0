From: Aaron Lu <aaron.lu@intel.com>
Subject: [RFC PATCH 1/2] ata: acpi: remove dead code for ata_acpi_(un)bind
Date: Thu, 25 Jul 2013 13:47:02 +0800
Message-ID: <1374731223-28685-2-git-send-email-aaron.lu@intel.com>
References: <1374731223-28685-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1374731223-28685-1-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Wu <jeff.wu@amd.com>, Shane Huang <shane.huang@amd.com>, Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>, Aaron Lu <aaron.lu@intel.com>, Zhang Rui <rui.zhang@intel.com>, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit 7381fe737 "libata-acpi: remove redundent code for power resource
handling" removed ata_acpi_(un)bind but left their prototypes in libata.h,
so remove them.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 577d902b..cc8a6e8 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -120,8 +120,6 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
-extern void ata_acpi_bind(struct ata_device *dev);
-extern void ata_acpi_unbind(struct ata_device *dev);
 extern void ata_acpi_hotplug_init(struct ata_host *host);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
@@ -133,8 +131,6 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
 static inline int ata_acpi_register(void) { return 0; }
 static inline void ata_acpi_unregister(void) { }
-static inline void ata_acpi_bind(struct ata_device *dev) { }
-static inline void ata_acpi_unbind(struct ata_device *dev) { }
 static inline void ata_acpi_hotplug_init(struct ata_host *host) {}
 #endif
 
-- 
1.8.3.2.10.g43d11f4

