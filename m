From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 1/4] pnp: pnpbios: Add explicit X86_32 dependency to PNPBIOS
Date: Mon, 11 Apr 2016 09:25:51 -0400
Message-ID: <bbb2f28f39cbda8923eedca61bb5d9c55520f674.1460379702.git.vilhelm.gray@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1460379702.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1460379702.git.vilhelm.gray@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, William Breathitt Gray <vilhelm.gray@gmail.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
List-Id: linux-scsi@vger.kernel.org

The PNPBIOS driver requires preprocessor defines (located in
include/asm/segment.h) only declared if the architecture is set to
X86_32. If the architecture is set to X86_64, the PNPBIOS driver will
not build properly. The X86 dependecy for the PNPBIOS configuration
option is changed to an explicit X86_32	dependency in order to prevent
an attempt to build for an unsupported architecture.

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 drivers/pnp/pnpbios/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pnp/pnpbios/Kconfig b/drivers/pnp/pnpbios/Kconfig
index 50c3dd0..a786086 100644
--- a/drivers/pnp/pnpbios/Kconfig
+++ b/drivers/pnp/pnpbios/Kconfig
@@ -3,7 +3,7 @@
 #
 config PNPBIOS
 	bool "Plug and Play BIOS support"
-	depends on ISA && X86
+	depends on ISA && X86_32
 	default n
 	---help---
 	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS
-- 
2.7.3
