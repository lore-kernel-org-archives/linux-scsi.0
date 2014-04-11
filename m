From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH trivial 1/3] megaraid_sas: Spelling s/intance/instance/
Date: Fri, 11 Apr 2014 06:02:39 +0000
Message-ID: <1323d0a306474383a4d3f50db610a8ce@DM2PR07MB400.namprd07.prod.outlook.com>
References: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:36658
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbaDKGCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Apr 2014 02:02:43 -0400
In-Reply-To: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, Jiri Kosina <trivial@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert+renesas@glider.be>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



>-----Original Message-----
>From: Geert Uytterhoeven [mailto:geert@linux-m68k.org]
>Sent: Tuesday, March 25, 2014 2:07 AM
>To: Jiri Kosina
>Cc: linux-kernel@vger.kernel.org; Geert Uytterhoeven; DL-MegaRAID Linux;
>linux-scsi@vger.kernel.org
>Subject: [PATCH trivial 1/3] megaraid_sas: Spelling s/intance/instance/
>
>From: Geert Uytterhoeven <geert+renesas@glider.be>
>
>Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
>Cc: linux-scsi@vger.kernel.org
>---
> drivers/scsi/megaraid/megaraid_sas_base.c   |    2 +-
> drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 3b7ad10497fe..10082678077c 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -3865,7 +3865,7 @@ fail_ready_state:
>
> /**
>  * megasas_release_mfi -	Reverses the FW initialization
>- * @intance:			Adapter soft state
>+ * @instance:			Adapter soft state
>  */
> static void megasas_release_mfi(struct megasas_instance *instance)  { diff --
>git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index f6555921fd7a..f7d68f65f974 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -2164,7 +2164,7 @@ megasas_issue_dcmd_fusion(struct
>megasas_instance *instance,
>
> /**
>  * megasas_release_fusion -	Reverses the FW initialization
>- * @intance:			Adapter soft state
>+ * @instance:			Adapter soft state
>  */
> void
> megasas_release_fusion(struct megasas_instance *instance)

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

-Sumit
>--
>1.7.9.5
>

