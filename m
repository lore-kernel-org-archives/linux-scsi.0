From: Ian Jackson <ian.jackson@eu.citrix.com>
Subject: [PATCH] [SCSI] libsas: Kconfig: Enable SATA compatibility by default
Date: Fri, 1 May 2015 15:36:18 +0100
Message-ID: <1430490978-1091-1-git-send-email-ian.jackson@eu.citrix.com>
References: <21826.14993.432271.52216@mariner.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:8570 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbbEAOgc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 May 2015 10:36:32 -0400
In-Reply-To: <21826.14993.432271.52216@mariner.uk.xensource.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: Ian Jackson <ian.jackson@eu.citrix.com>, Ian Jackson <Ian.Jackson@eu.citrix.com>, James Bottomley <James.Bottomley@suse.de>, Donald D Dugger <donald.d.dugger@intel.com>, Pawel Baldysiak <pawel.baldysiak@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Ian Campbell <ian.campbell@citrix.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>

SATA controllers support SATA disks.  The kernel should be able to
drive these, by default.  It should not silently (apart from a
debugging-only printk) ignore them.

Signed-off-by: Ian Jackson <Ian.Jackson@eu.citrix.com>
CC: James Bottomley <James.Bottomley@suse.de>
CC: Donald D Dugger <donald.d.dugger@intel.com>
CC: Pawel Baldysiak <pawel.baldysiak@intel.com>
CC: Lukasz Dorau <lukasz.dorau@intel.com>
CC: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
CC: Ian Campbell <ian.campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>
---
 drivers/scsi/libsas/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 9dafe64..16258b0 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -34,6 +34,7 @@ config SCSI_SAS_ATA
 	bool "ATA support for libsas (requires libata)"
 	depends on SCSI_SAS_LIBSAS
 	depends on ATA = y || ATA = SCSI_SAS_LIBSAS
+	default y
 	help
 		Builds in ATA support into libsas.  Will necessitate
 		the loading of libata along with libsas.
-- 
1.7.10.4

