Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4843E6BFB0;
	Tue, 18 Jun 2024 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718723919; cv=none; b=SApynrt0nzszrlSnTbwLI5shtGWz5AG9vfzB6V7uvpcnx9gu+TChQPHf3AfiwDw59BhrbKSAgcD2atuvLLexmbXBasNjfk2ib5Dku6vZvONst8TCwIL+a0+pl+kKxb6ebZhIAxmOR0E4GCbdjvWPzKzp2wgZwNKcTqBpeMHzJ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718723919; c=relaxed/simple;
	bh=4HYzkCyMIH1bQMt4sBkTNq8QrB4AOvLgwFW3TO6rwK0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=fWRbbLLkt6ojDMRRcJtVVgIcVftnW37V6t8PGfMbXYjd8btULIeBHpPR7b0TTvZEdidDm6pOz/q/Xh3ta4/8ATEfKm/pg1n4V5YLFh45nJFaYWLf5hXaYGM7OJKKEVr1gdPjolU+BE4WMjqzTU3nkMz5c4fytRZK3GrjZB6a+SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=geE5LFiZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="geE5LFiZ"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45ICqgwc006175;
	Tue, 18 Jun 2024 15:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Durdm3Ss1qe6LtFrzIfT5W
	eOKJaKnsW3YZanyZgKCYI=; b=geE5LFiZpxL0oN4j3J60RN06NdzGlkXetSMFSr
	wZ5dw4UXp1axMzC+sqDV/MzEpeyzOEvpmPAJI3cxFr9VI+UA0KRUoiiQj/sZuHIa
	xDDnjb8dgdLEsCfVVATifNWN+ntDH0xFCpzOCM5e9egJUB2fspo0mbqg17DG4bDh
	T0jIsLxeHD25azL1VrJoW4vdTtN4n1JfSFl9RHDIViSdB9ON90XolXb7sg56mi2s
	qWJBqaHhXQuoKINzvdtnnF7cutueGqdmb9rKDqTTB4Xajgaf30oUSZmUEIFGPkWm
	HhbbsNnhDXjqMqRdA5WkEIQReNIQC3S4547xyY9TgVLG8Kpw==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yuamp0cmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 15:18:28 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45IFIR1W011196
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 15:18:27 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 18 Jun
 2024 08:18:27 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Tue, 18 Jun 2024 08:18:26 -0700
Subject: [PATCH v2] usb: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240618-md-drivers-usb-v2-1-e9b20a5eb7f9@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAEGlcWYC/3WNyw6CMBBFf4V07RiKWoor/8Ow6GOUSaRoBxoM4
 d8t7F2e5N5zFsEYCVlci0VETMQ0hAzVoRCuM+GJQD6zqMrqXCopoffgIyWMDBNb0KppGn+p0Us
 l8ukd8UHzLry3ma1hBBtNcN2meVGYZugNjxi3eUc8DvG755PcTn9LSYIEbbVXqkGN9en2mchRc
 Ec39KJd1/UHbgaEWM0AAAA=
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
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: nhU7BEU7uW8DlvoFktTopxPNM_nIwuxx
X-Proofpoint-GUID: nhU7BEU7uW8DlvoFktTopxPNM_nIwuxx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406180114

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
Changes in v2:
- Updated drivers/usb/core/usb.c description per Alan
- Link to v1: https://lore.kernel.org/r/20240611-md-drivers-usb-v1-1-8b8d669e8e73@quicinc.com
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
index a0c432b14b20..0b4685aad2d5 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -1150,4 +1150,5 @@ static void __exit usb_exit(void)
 
 subsys_initcall(usb_init);
 module_exit(usb_exit);
+MODULE_DESCRIPTION("USB core host-side support");
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

