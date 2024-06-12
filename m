Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BEAB651;
	Wed, 12 Jun 2024 02:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718159851; cv=none; b=mEBztCV3LFRNJfSsOb4kBV/2DAdrALrdTcwO6hJBpL1EjTPvi088zi4brVxvOXDU4TDTJDwzeJVQ5W5w84ShNscwRohvN+dY0UCwXU1ooUworTTxQucViiJXIgEtndG9MzPS9aYWB+TllJQxnWTomiqpHW7ePUdYSdrG0VPTHmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718159851; c=relaxed/simple;
	bh=FIlZ1Po+7l5jXHSE5OgRVwHa3qfDT39V0YMl45YwWI8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=jY9cCYbY4nu2VPxKfwdq8AimQn7aAPKXDU7fIUTrYHEERlaL9T5RHyHoluoBSYhWUFKeuhLfo+7ZVVdN/JV4ibYdRC2yFqjvVwMv/IAhVc7B892GrvleqREvmurIHu/s28TSDw6iWfsho1z4kMTg7RXgEXe1Ziohh0r9zinNs1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=JNRGtLfp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="JNRGtLfp"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BDmAGv011284;
	Wed, 12 Jun 2024 02:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=dL/OjdmAVSy+SNFQu2VJRG
	bXRL5/DpTz2Gw/w62br+c=; b=JNRGtLfpSo5M+5/4+21aQbQ9PyQEx4sllodK5+
	gduT8hW75PTYbtMw3HYLxqgVgDuRerdd/0cHmncDai2Tlt6IgL7HctMgPXG4vHWF
	nJCnLHtd9bC3kiUrtq9Q9R2AQJT7H6yQZARGtnaS6XSYMdtN9AprOW8bVZzO9Xtt
	mvzWV9/sm/l4VwAQIh0Kt/jDe/HLrvN4xf1ICWryEmRoi+dKGLRkG8cYDqLdt9Aw
	eAomOgd/JCcMjBy5/duS0CmaGh8JzC/Cqjq8Orfb5ieRbynT/7IY/z6+RYAtXpWY
	I+N489+/BZqiT/34XZIysxC8FGIV/FeJPA2N1lZ5edYb5RzA==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ymcnmyw5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 02:37:23 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45C2bM1i016440
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 02:37:22 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 11 Jun
 2024 19:37:22 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Tue, 11 Jun 2024 19:37:20 -0700
Subject: [PATCH] usb: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240611-md-drivers-usb-v1-1-8b8d669e8e73@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAN8JaWYC/x3MwQqDMAyA4VeRnBewMrt1rzJ2aE02A1pHoiKI7
 26343f4/x2MVdjgUe2gvIrJlAvcpYKuj/nDKFQMTd1ca+8cjoSksrIaLpbw7kMI1N6YnIcSfZX
 fsv2Hz1dxisaYNOau/20GycuGY7SZFY7jBLnTZiJ/AAAA
To: Peter Chen <peter.chen@kernel.org>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        Alan Stern
	<stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: JDBySRTaunjx1iEhh1rC7EVO5Nj43UbF
X-Proofpoint-ORIG-GUID: JDBySRTaunjx1iEhh1rC7EVO5Nj43UbF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_13,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 clxscore=1011 adultscore=0 phishscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406120016

With ARCH=x86, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/core/usbcore.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/mon/usbmon.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/class/usbtmc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/storage/uas.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/chipidea/ci_hdrc_msm.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
This is the remaining one-off fixes in usb.

Corrections to these descriptions are welcomed. I'm not an expert in
this code so in most cases I've taken these descriptions directly from
code comments, Kconfig descriptions, or git logs.  History has shown
that in some cases these are originally wrong due to cut-n-paste
errors, and in other cases the drivers have evolved such that the
original information is no longer accurate.

Let me know if any of these changes need to be segregated into
separate patches to go through different maintainer trees.
---
 drivers/usb/chipidea/ci_hdrc_msm.c | 1 +
 drivers/usb/class/usbtmc.c         | 1 +
 drivers/usb/core/usb.c             | 1 +
 drivers/usb/mon/mon_main.c         | 1 +
 drivers/usb/storage/uas.c          | 1 +
 5 files changed, 5 insertions(+)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index 7b5b47ce8a02..1661639cd2eb 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -303,4 +303,5 @@ module_platform_driver(ci_hdrc_msm_driver);
 
 MODULE_ALIAS("platform:msm_hsusb");
 MODULE_ALIAS("platform:ci13xxx_msm");
+MODULE_DESCRIPTION("ChipIdea Highspeed Dual Role Controller");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 311007b1d904..6bd9fe565385 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2592,4 +2592,5 @@ static struct usb_driver usbtmc_driver = {
 
 module_usb_driver(usbtmc_driver);
 
+MODULE_DESCRIPTION("USB Test & Measurement class driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index a0c432b14b20..65f9940bc7e8 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -1150,4 +1150,5 @@ static void __exit usb_exit(void)
 
 subsys_initcall(usb_init);
 module_exit(usb_exit);
+MODULE_DESCRIPTION("USB support library");
 MODULE_LICENSE("GPL");
diff --git a/drivers/usb/mon/mon_main.c b/drivers/usb/mon/mon_main.c
index 824904abe76f..af852d53aac6 100644
--- a/drivers/usb/mon/mon_main.c
+++ b/drivers/usb/mon/mon_main.c
@@ -419,4 +419,5 @@ static void __exit mon_exit(void)
 module_init(mon_init);
 module_exit(mon_exit);
 
+MODULE_DESCRIPTION("USB Monitor");
 MODULE_LICENSE("GPL");
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index a48870a87a29..9b8f578eef53 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1280,6 +1280,7 @@ static void __exit uas_exit(void)
 module_init(uas_init);
 module_exit(uas_exit);
 
+MODULE_DESCRIPTION("USB Attached SCSI driver");
 MODULE_LICENSE("GPL");
 MODULE_IMPORT_NS(USB_STORAGE);
 MODULE_AUTHOR(

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240611-md-drivers-usb-86999d57ed16

