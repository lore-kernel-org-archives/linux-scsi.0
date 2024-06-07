Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219A41CD02;
	Fri,  7 Jun 2024 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717789419; cv=none; b=mjshqRvOW3icaJZUqnIqXigvnFtFPsnZykn9EmFUe6whq3WSUtC1HkT9qRhKc/9iFeEA3IIdw0Q9iPJ990ap3Uw9DHx/q15XIlQBNbS9ldZq9Ii329MrSYx9QZwaO1OQ1pxM8U7bWLmtqnGfwMNJ8MueDiv4d/+whI7xvqEEN1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717789419; c=relaxed/simple;
	bh=8cobZlcEyp9CDfr4HrSZ9SQXkL9DjmZKyYuhhR1B60o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=hRWjWjWOMYbsfMy01HMJI9TT/TZ94ZurYAwm+dJlKOxtecymBPEezD5f3yTCgZPEDGhR3m1Ar70+WLCqFxO5ExniksCGgHqUJs/A0vbEucxqog5bfqwh5FwFwsp6U47gi5u1yGmfcqMlyXLZiunH7mlYFJkpYf1PB9bLmVvbWJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=CDxfiOAH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="CDxfiOAH"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 457HZUZD012451;
	Fri, 7 Jun 2024 19:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=AHdKNN+sYSEGCBs/kKLwzr
	wABfUxALoBlk5QUgSHAP0=; b=CDxfiOAH+StH5QmxCbksFZoqDBvnOtq9p4N2Tr
	QTnKjdgLS3fqwwZ9VDr6e0gu78McPBi+BPlAkauZHG7LQO7e9ssXc+Fou15FHLha
	z8bMlxtbwOuSO603WA1cUoY02wScEe3VEyseFnj/QCZiEdfjvgsyLvCQzXbSkbep
	UbjllV/sGs6lpB+lX25j4kX6LyLjIqImTmxG4hdboU7C5x01ppG/nbICdBaeQAN8
	wc+aaTRDkMk6xh5SViQ8Tu4VyRZUxY/4jgU6DnGzGLLP0375aQdl4ZPsnul9qFTb
	+/SkrugZ3tUWFH/2wGXgWBi4EbYOeHSauX/Y/1A2+luhOg7Q==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yjvxye09p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Jun 2024 19:43:11 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 457JhAKE027188
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 7 Jun 2024 19:43:10 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 7 Jun 2024
 12:43:10 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Fri, 7 Jun 2024 12:43:09 -0700
Subject: [PATCH] scsi: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240607-md-drivers-scsi-v1-1-17ae31cc4fe5@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAMxiY2YC/x3M3QqCQBCG4VuROW5gc0WxW4kO9ucrB3KLGRNBv
 Pe2Dp+D993JoAKjS7OTYhWTV6k4nxpKUygPsORqal3bud4NPGfOKivU2JIJw/u+c4PHGEeq1Vt
 xl+1/vN6qYzBw1FDS9Ps8pXw2noMtUDqOLxy6tE+AAAAA
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
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: fiNwnI5Q2Lc0oxWWL2LD54E7wO47kZig
X-Proofpoint-GUID: fiNwnI5Q2Lc0oxWWL2LD54E7wO47kZig
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-07_12,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406070145

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

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/scsi/BusLogic.c             | 1 +
 drivers/scsi/advansys.c             | 1 +
 drivers/scsi/aha1542.c              | 1 +
 drivers/scsi/aha1740.c              | 1 +
 drivers/scsi/atari_scsi.c           | 1 +
 drivers/scsi/atp870u.c              | 1 +
 drivers/scsi/elx/efct/efct_driver.c | 1 +
 drivers/scsi/g_NCR5380.c            | 1 +
 drivers/scsi/imm.c                  | 1 +
 drivers/scsi/initio.c               | 2 ++
 drivers/scsi/isci/init.c            | 1 +
 drivers/scsi/mac_scsi.c             | 1 +
 drivers/scsi/pcmcia/aha152x_stub.c  | 1 +
 drivers/scsi/ppa.c                  | 1 +
 drivers/scsi/scsi_common.c          | 1 +
 drivers/scsi/sr.c                   | 2 ++
 drivers/scsi/sun3_scsi.c            | 1 +
 17 files changed, 19 insertions(+)

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
index 9503996c6325..add10098a569 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1009,6 +1009,7 @@ static int aha1542_biosparam(struct scsi_device *sdev,
 
 	return 0;
 }
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
index 742625ac7d99..4eb5770aeef5 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -894,4 +894,5 @@ static struct platform_driver atari_scsi_driver __refdata = {
 module_platform_driver_probe(atari_scsi_driver, atari_scsi_probe);
 
 MODULE_ALIAS("platform:" DRV_MODULE_NAME);
+MODULE_DESCRIPTION("Atari generic SCSI port driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 2a748af269c2..3f006b2f39a6 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1724,6 +1724,7 @@ static void atp870u_remove (struct pci_dev *pdev)
 	atp870u_free_tables(pshost);
 	scsi_host_put(pshost);
 }
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
index f6305e3e60f4..1bef131664e0 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -110,6 +110,7 @@ module_param_array(card, int, NULL, 0);
 MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC3181E, 4=HP C2502)");
 
 MODULE_ALIAS("g_NCR5380_mmio");
+MODULE_DESCRIPTION("Generic NCR5380 driver");
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
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 625fd547ee60..82d8b8f8293f 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2939,6 +2939,7 @@ static void initio_remove_one(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+MODULE_DESCRIPTION("Initio 9100U(W) driver");
 MODULE_LICENSE("GPL");
 
 static struct pci_device_id initio_pci_tbl[] = {
@@ -2961,4 +2962,5 @@ module_pci_driver(initio_pci_driver);
 
 MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
 MODULE_AUTHOR("Initio Corporation");
+MODULE_DESCRIPTION("TBD");
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
index a402c4dc4645..f74231ca29e5 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -550,4 +550,5 @@ static struct platform_driver mac_scsi_driver __refdata = {
 module_platform_driver_probe(mac_scsi_driver, mac_scsi_probe);
 
 MODULE_ALIAS("platform:" DRV_MODULE_NAME);
+MODULE_DESCRIPTION("Generic Macintosh NCR5380 driver");
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
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ab000942b97..c4a88f673183 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -68,6 +68,7 @@
 
 
 MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
+MODULE_DESCRIPTION("TBD");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_ROM);
@@ -1007,4 +1008,5 @@ static void __exit exit_sr(void)
 
 module_init(init_sr);
 module_exit(exit_sr);
+MODULE_DESCRIPTION("SCSI CDROM driver");
 MODULE_LICENSE("GPL");
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

