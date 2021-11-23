Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86911C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhKWDwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:52:23 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28286 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231819AbhKWDwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:52:22 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN1unHj013598;
        Tue, 23 Nov 2021 03:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=BgHrdj1DiKSY/8OAHoPvNY6ppS7Ql/1Xxe5wlW/6JJU=;
 b=ZPyylL1zMgpBxnu4/2GiwMqxg3ZacYd7uQ2KzN3lEH1ZtjBZZ8JO808sNASYRxtuT0FC
 9YTZFsvl2aW4ydOR7eDo2bHXpr/xsf0fL585tSYs9KinFPbPkbAC+xgolu/6TLJH3v+q
 GQiE508pPub1cF12MpbDJ9dXYt5EJbVFbz6IRUkdZMGu/uTAG0SAzCn2ecmAMuAXDewH
 ql562TnB90ZVzxMNr8qC5ksRsqi8ZVDRSRK91I/7sZXdCF13SRYDWgTvAkBuBPboi/OL
 7c1JyYH/oi1P2wNDnZ32d/2HXulWZoRHCcOi0Y0IMbNyb50f1Z/olGynBgnBZW83CyBM yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg69medtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3l2GR162355;
        Tue, 23 Nov 2021 03:49:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:08 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3l19o162141;
        Tue, 23 Nov 2021 03:49:08 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6hc-4;
        Tue, 23 Nov 2021 03:49:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Avri Altman <avri.altman@wdc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Fix double space in SCSI_UFS_HWMON description
Date:   Mon, 22 Nov 2021 22:49:02 -0500
Message-Id: <163763931254.19362.542551491549735127.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211106164741.1571206-1-geert@linux-m68k.org>
References: <20211106164741.1571206-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: m3-9AipTTyhMMxaMJJ1BBgFK7gPfJQa8
X-Proofpoint-ORIG-GUID: m3-9AipTTyhMMxaMJJ1BBgFK7gPfJQa8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 6 Nov 2021 17:47:41 +0100, Geert Uytterhoeven wrote:

> There's no reason to have a double space between "UFS" and
> "Temperature", hence drop it.
> 
> 

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: ufs: Fix double space in SCSI_UFS_HWMON description
      https://git.kernel.org/mkp/scsi/c/659109a45c6c

-- 
Martin K. Petersen	Oracle Linux Engineering
