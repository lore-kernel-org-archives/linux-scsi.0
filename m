From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] megaraid: update version reported by MEGAIOC_QDRVRVER
Date: Fri, 20 Apr 2007 15:36:15 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229A589F0@NAMAIL2.ad.lsil.com>
References: <20070419171024.GA6885@dhcp-210.hsv.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60260 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767269AbXDTVg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2007 17:36:28 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070419171024.GA6885@dhcp-210.hsv.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, "Yang, Bo" <Bo.Yang@lsi.com>

 
ACK.

Thank you David.

Regards,

Sumant

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of David Milburn
Sent: Thursday, April 19, 2007 10:10 AM
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org; dmilburn@redhat.com
Subject: [PATCH] megaraid: update version reported by MEGAIOC_QDRVRVER

Update the driver version reported by MEGAIOC_QDRVRVER to match
LSI_COMMON_MOD_VERSION.

Signed-off-by: David Milburn <dmilburn@redhat.com>
---

 drivers/scsi/megaraid/megaraid_mm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c
b/drivers/scsi/megaraid/megaraid_mm.c
index f33a678..e075a52 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL(mraid_mm_unregister_adp);
 EXPORT_SYMBOL(mraid_mm_adapter_app_handle);
 
 static int majorno;
-static uint32_t drvr_ver	= 0x02200206;
+static uint32_t drvr_ver	= 0x02200207;
 
 static int adapters_count_g;
 static struct list_head adapters_list_g;
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
