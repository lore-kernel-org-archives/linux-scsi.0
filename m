From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: [PATCH] modify the type of element of MessageUnit_B in arcmsr
Date: Tue, 4 Mar 2008 17:49:59 +0800
Message-ID: <005e01c87ddd$1c22db70$8800a8c0@Nick>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_005F_01C87E20.2A461B70"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:36210 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756084AbYCDJuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 04:50:11 -0500
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, 'Tomas Henzl' <thenzl@redhat.com>, viro@ftp.linux.org.uk

This is a multi-part message in MIME format.

------=_NextPart_000_005F_01C87E20.2A461B70
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Subject: [PATCH] scsi: modify the element type of MessageUnit_B in
arcmsr-1.20.00.15-80227
From: Nick Cheng <nick.cheng@areca.com.tw>
Description:
*** modify the element type of MessageUnit_B in arcmsr-1.20.00.15-80227 to
keep off the error while doing iounmap in arcmsr_free_ccb_pool()
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

------=_NextPart_000_005F_01C87E20.2A461B70
Content-Type: application/octet-stream;
	name="patch4arcmsr"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch4arcmsr"

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
index 0393707..3288be2 100644=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h=0A=
@@ -341,13 +341,13 @@ struct MessageUnit_B=0A=
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
 	uint32_t	postq_index;=0A=
 	uint32_t	doneq_index;=0A=
-	uint32_t	__iomem *drv2iop_doorbell_reg;=0A=
-	uint32_t	__iomem *drv2iop_doorbell_mask_reg;=0A=
-	uint32_t	__iomem *iop2drv_doorbell_reg;=0A=
-	uint32_t	__iomem *iop2drv_doorbell_mask_reg;=0A=
-	uint32_t	__iomem *msgcode_rwbuffer_reg;=0A=
-	uint32_t	__iomem *ioctl_wbuffer_reg;=0A=
-	uint32_t	__iomem *ioctl_rbuffer_reg;=0A=
+	void		__iomem *drv2iop_doorbell_reg;=0A=
+	void		__iomem *drv2iop_doorbell_mask_reg;=0A=
+	void		__iomem *iop2drv_doorbell_reg;=0A=
+	void		__iomem *iop2drv_doorbell_mask_reg;=0A=
+	void		__iomem *msgcode_rwbuffer_reg;=0A=
+	void		__iomem *ioctl_wbuffer_reg;=0A=
+	void		__iomem *ioctl_rbuffer_reg;=0A=
 };=0A=
 =0A=
 /*=0A=

------=_NextPart_000_005F_01C87E20.2A461B70--

