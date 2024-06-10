Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675771DFF7;
	Mon, 10 Jun 2024 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718036201; cv=none; b=TzrS/ycQmxnv60HHbFXvtABu5gItsZjJXlZMu3cqOzWPfPhySoRpFL9LeGEFUk240cU66rmt4DU27exOIMncyGqaFs6W3LcSX9SZeGWHYxY7eoG69/yg3gR/LtoXCvEDPJw9CCVVGkLxQ1Ojn8aM0jrG9USXwYN4Zar++Da+zrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718036201; c=relaxed/simple;
	bh=lJJVRDaDKBtRiy5dp2Z/Xvx+mfKgJ+g7wu4EAoB+3Rc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=V2jBM/IijqQ4yDVAgoiZdf6e+lISLam2elPGISgY69GEzGwl5bXJQlthXmVPDPwpFwKEBsYyPPq3Z8QDoImGxZPj123H9VZhqTR7ARrre4fq3kbipNt+aJBY4Rk4bGBdQLw7tWWdgyzoZKaXNIlL6GSplwR77UfR0H5+9RSL0ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=nD/9LrSs; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="nD/9LrSs"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45AFDMep024236;
	Mon, 10 Jun 2024 16:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=+2SgnZTd/Jy9fjHWzehQ8D
	XP+8WphTGJbo3+JOtqyt8=; b=nD/9LrSsGd7nRhPDJZqdmqu/ZJJtBZ7kGrqskt
	kkd4SyZ/Fl0Lg952upa0J1bA0vdmYXvFTiwLfxcz8b3atGtYAEQwxkYnNlQnBqOn
	WNUgx/73QcsaYbH+jVM4Z848HaRky1pcHglUjKFwzQzEBl0OugwILgLVMtRQPwSu
	8w12J8Nzje0X307rECrb6UgjZMuqGbEkfblJtshef9W05DXmPkHUzDZjBD2KaoxU
	j4Lpf64ScThhBC/MMKG3aVR+O94dme0qOfKGBm8IssBrGRLIMojhhAVQaIdOTV3f
	KRD4IKd3AiCkW0k4/kb0NpyYJXijVzR0H5qDaZ7p+msZPqEA==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yme8rvg92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 16:16:20 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45AGGGqp011292
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 16:16:16 GMT
Received: from [169.254.0.1] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 10 Jun
 2024 09:16:16 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Mon, 10 Jun 2024 09:16:15 -0700
Subject: [PATCH v3] scsi: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240610-md-drivers-scsi-v3-1-055da78d66b2@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAM4mZ2YC/3WNQQ6CMBBFr0K6tqa0BcSV9zAuSjvKJFK0Aw2Gc
 HcLK40xs3rJ/PdmRhAQiB2zmQWISNj7BGqXMdsafwOOLjGTQmpRiop3jruAEQJxsoQclCq1qBT
 UTc3S6hHgitNmPF8SN4aAN8F4266eO/px4p2hAcL63iINfXht/Zivo/+pmPN0lQGVW6uvUJyeI
 1r0dm/7jq2xKD8Nh1+DTAYnhCsLCYVT+tuwLMsbI9ZJIhEBAAA=
To: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
	<martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Hannes
 Reinecke" <hare@suse.com>, Finn Thain <fthain@linux-m68k.org>,
        Michael
 Schmitz <schmitzmic@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Ram
 Vegesna <ram.vegesna@broadcom.com>,
        Artur Paszkiewicz
	<artur.paszkiewicz@intel.com>,
        "Juergen E. Fischer" <fischer@norbit.de>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 5qpEp2i0nmmmlVnMTFqH9pz83Sqt6mda
X-Proofpoint-GUID: 5qpEp2i0nmmmlVnMTFqH9pz83Sqt6mda
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_03,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406100122

On x86, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/scsi_common.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/advansys.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/BusLogic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/aha1740.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/isci/isci.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/elx/efct.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/atp870u.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/ppa.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/imm.o

Add all missing invocations of the MODULE_DESCRIPTION() macro.

This updates all files which have a MODULE_LICENSE() but which do not
have a MODULE_DESCRIPTION(), even ones which did not produce the x86
allmodconfig warnings.

Acked-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
Changes in v3:
- Added missing newlines in aha1542.c and atp870u.c
- Link to v2: https://lore.kernel.org/r/20240608-md-drivers-scsi-v2-1-d00d652e5d34@quicinc.com

Changes in v2:
- Updated descriptions of atari_scsi.c, g_NCR5380.c, mac_scsi.c per Finn Thain
  & Michael Schmitz
- Removed unnecessary modifications to initio.c and sr.c
- Link to v1: https://lore.kernel.org/r/20240607-md-drivers-scsi-v1-1-17ae31cc4fe5@quicinc.com
---
 drivers/scsi/BusLogic.c             | 1 +
 drivers/scsi/advansys.c             | 1 +
 drivers/scsi/aha1542.c              | 2 ++
 drivers/scsi/aha1740.c              | 1 +
 drivers/scsi/atari_scsi.c           | 1 +
 drivers/scsi/atp870u.c              | 2 ++
 drivers/scsi/elx/efct/efct_driver.c | 1 +
 drivers/scsi/g_NCR5380.c            | 1 +
 drivers/scsi/imm.c                  | 1 +
 drivers/scsi/isci/init.c            | 1 +
 drivers/scsi/mac_scsi.c             | 1 +
 drivers/scsi/pcmcia/aha152x_stub.c  | 1 +
 drivers/scsi/ppa.c                  | 1 +
 drivers/scsi/scsi_common.c          | 1 +
 drivers/scsi/sun3_scsi.c            | 1 +
 15 files changed, 17 insertions(+)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 72ceaf650b0d..2135a2b3e2d0 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -78,6 +78,7 @@ static struct blogic_drvr_options blogic_drvr_options[BLOGIC_MAX_ADAPTERS];
   BusLogic can be assigned a string by insmod.
 */
 
+MODULE_DESCRIPTION("BusLogic MultiMaster and FlashPoint SCSI Host Adapter driver");
 MODULE_LICENSE("GPL");
 #ifdef MODULE
 static char *BusLogic;
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ab066bb27a57..fd4fcb37863d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11545,6 +11545,7 @@ static void __exit advansys_exit(void)
 module_init(advansys_init);
 module_exit(advansys_exit);
 
+MODULE_DESCRIPTION("AdvanSys SCSI Adapter driver");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE("advansys/mcode.bin");
 MODULE_FIRMWARE("advansys/3550.bin");
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 9503996c6325..389499d3e00a 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1009,6 +1009,8 @@ static int aha1542_biosparam(struct scsi_device *sdev,
 
 	return 0;
 }
+
+MODULE_DESCRIPTION("Adaptec AHA-1542 SCSI host adapter driver");
 MODULE_LICENSE("GPL");
 
 static int aha1542_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 3d18945abaf7..be7ebbbb9ba8 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -681,4 +681,5 @@ static __exit void aha1740_exit (void)
 module_init (aha1740_init);
 module_exit (aha1740_exit);
 
+MODULE_DESCRIPTION("Adaptec AHA1740 SCSI host adapter driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 742625ac7d99..98a1b966a0b0 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -894,4 +894,5 @@ static struct platform_driver atari_scsi_driver __refdata = {
 module_platform_driver_probe(atari_scsi_driver, atari_scsi_probe);
 
 MODULE_ALIAS("platform:" DRV_MODULE_NAME);
+MODULE_DESCRIPTION("Atari TT/Falcon NCR5380 SCSI driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 2a748af269c2..928151ec927a 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1724,6 +1724,8 @@ static void atp870u_remove (struct pci_dev *pdev)
 	atp870u_free_tables(pshost);
 	scsi_host_put(pshost);
 }
+
+MODULE_DESCRIPTION("ACARD SCSI host adapter driver");
 MODULE_LICENSE("GPL");
 
 static const struct scsi_host_template atp870u_template = {
diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 49fd2cfed70c..55d2301bfd7d 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -778,5 +778,6 @@ static void __exit efct_exit(void)
 module_init(efct_init);
 module_exit(efct_exit);
 MODULE_VERSION(EFCT_DRIVER_VERSION);
+MODULE_DESCRIPTION("Emulex Fibre Channel Target driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Broadcom");
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index f6305e3e60f4..270eae7ac427 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -110,6 +110,7 @@ module_param_array(card, int, NULL, 0);
 MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC3181E, 4=HP C2502)");
 
 MODULE_ALIAS("g_NCR5380_mmio");
+MODULE_DESCRIPTION("Generic NCR5380/NCR53C400 SCSI driver");
 MODULE_LICENSE("GPL");
 
 static void g_NCR5380_trigger_irq(struct Scsi_Host *instance)
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 21339da505f1..6e779bb14d98 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1279,4 +1279,5 @@ static struct parport_driver imm_driver = {
 };
 module_parport_driver(imm_driver);
 
+MODULE_DESCRIPTION("IOMEGA MatchMaker parallel port SCSI host adapter driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index de2aefcf2089..d31884f82f2a 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -758,6 +758,7 @@ static __exit void isci_exit(void)
 	sas_release_transport(isci_transport_template);
 }
 
+MODULE_DESCRIPTION("Intel(R) C600 Series Chipset SAS Controller driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_FIRMWARE(ISCI_FW_NAME);
 module_init(isci_init);
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index a402c4dc4645..53ee8f84d094 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -550,4 +550,5 @@ static struct platform_driver mac_scsi_driver __refdata = {
 module_platform_driver_probe(mac_scsi_driver, mac_scsi_probe);
 
 MODULE_ALIAS("platform:" DRV_MODULE_NAME);
+MODULE_DESCRIPTION("Macintosh NCR5380 SCSI driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 6a6621728c69..1b54ba51a485 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -75,6 +75,7 @@ module_param(synchronous, int, 0);
 module_param(reset_delay, int, 0);
 module_param(ext_trans, int, 0);
 
+MODULE_DESCRIPTION("Adaptec AHA152X-compatible PCMCIA SCSI card driver");
 MODULE_LICENSE("Dual MPL/GPL");
 
 /*====================================================================*/
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 8300f0bdddb3..2d9fcc45ad85 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -1155,4 +1155,5 @@ static struct parport_driver ppa_driver = {
 };
 module_parport_driver(ppa_driver);
 
+MODULE_DESCRIPTION("IOMEGA PPA3 parallel port SCSI host adapter driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 9c14fdf61037..04749fde1636 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -12,6 +12,7 @@
 #include <asm/unaligned.h>
 #include <scsi/scsi_common.h>
 
+MODULE_DESCRIPTION("SCSI functions used by both the initiator and the target code");
 MODULE_LICENSE("GPL v2");
 
 /* Command group 3 is reserved and should never be used.  */
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 4a8cc2e8238e..f51702893306 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -666,4 +666,5 @@ static struct platform_driver sun3_scsi_driver = {
 module_platform_driver_probe(sun3_scsi_driver, sun3_scsi_probe);
 
 MODULE_ALIAS("platform:" DRV_MODULE_NAME);
+MODULE_DESCRIPTION("Sun3 NCR5380 SCSI controller driver");
 MODULE_LICENSE("GPL");

---
base-commit: 19ca0d8a433ff37018f9429f7e7739e9f3d3d2b4
change-id: 20240607-md-drivers-scsi-e3364073e9b9

